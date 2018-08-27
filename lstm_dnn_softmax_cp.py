import os
#os.environ['TF_CPP_MIN_LOG_LEVEL'] = ''
#os.environ["CUDA_VISIBLE_DEVICES"] = "0"
import tensorflow as tf
import numpy as np
import logging
import time
from data_manage import DataManager

from tensorflow.examples.tutorials.mnist import input_data
mnist = input_data.read_data_sets("/home/nan/PycharmProjects/MachineLearning/data/MNIST_data/", one_hot=True)

# trainDataManger = # DataManager("/do/home/liujunnan/SR/code/lre2018/ap18-run/data/train/feats.scp",
#                               "/do/home/liujunnan/SR/code/lre2018/ap18-run/data/train/utt2lang")
# testDataManger = # DataManager("/do/home/liujunnan/SR/code/lre2018/ap18-run/data/test_1s/feats.scp", None)

# label_dict = {0:"ct-cn",1:"id-id",2:"ja-jp",3:"ko-kr",4:"ru-ru",5:"vi-vn",6:"zh-cn"}
label_dict = {'ct':0,    'id':1,    'ja':2,    'kazak':3, 'ko':4,    'ru':5,    'tibetan':6, 'uyghur':7, 'vi':8,    'zh':9}
# lang_list2 = ['ct-cn', 'id-id', 'ja-jp', 'Kazak', 'ko-kr', 'ru-ru', 'Tibet',   'Uyghu',  'vi-vn', 'zh-cn']

working_type = 1

'''
logger setting
'''
logger = logging.getLogger("lstm")
logger.setLevel(logging.INFO)
handler = logging.FileHandler("lstm-lr.log")
handler.setLevel(logging.INFO)
formatter = logging.Formatter(
	'%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)

def getLogger():
        return logger


MOVING_AVERAGE_DECAY = 0.9999  # The decay to use for the moving average.
NUM_EPOCHS_PER_DECAY = 350.0  # Epochs after which learning rate decays.
LEARNING_RATE_DECAY_FACTOR = 0.1  # Learning rate decay factor.
INITIAL_LEARNING_RATE = 0.1  # Initial learning rate.

FLAGS = tf.app.flags.FLAGS

tf.app.flags.DEFINE_string('data_dir', '/home/norman/MNIST_data',
                           """Path to the MNIST data directory.""")
tf.app.flags.DEFINE_string('train_dir', '/home/norman/MNIST_train',
                           """Directory where to write event logs """
                           """and checkpoint.""")

tf.app.flags.DEFINE_integer('batch_size', 40,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('feature_size', 28,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('lstm_hidden_size', 256,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('dnn_hidden_size', 512,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('softmax_size', 10,
                            """Number of images to process in a batch.""")


tf.app.flags.DEFINE_integer('max_train_step', 500,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('checkpoint_interval', 5,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('validation_interval', 5,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('summary_interval', 10,
                            """Number of images to process in a batch.""")
tf.app.flags.DEFINE_integer('decay_step', 5,
                            """Number of images to process in a batch.""")


tf.app.flags.DEFINE_integer('num_gpus', 1,
                            """How many GPUs to use.""")

tf.app.flags.DEFINE_float('keep_prob', 1.0,
                            """How many GPUs to use.""")
tf.app.flags.DEFINE_float('learning_rate', 0.001,
                            """How many GPUs to use.""")
tf.app.flags.DEFINE_float('learning_rate_decay', 0.5,
                            """How many GPUs to use.""")

tf.app.flags.DEFINE_boolean('tb_logging', True,
                            """Whether to log to Tensorboard.""")
tf.app.flags.DEFINE_boolean('log_device_placement', False,
                            """Whether to log device placement.""")

        


def LSTM_Layer(lstm_hidden_size, layer_name, keep_prob):
    with tf.name_scope(layer_name) as scope:
        lstm_layer = tf.nn.rnn_cell.BasicLSTMCell(
	    num_units=lstm_hidden_size, forget_bias=1.0, state_is_tuple=True)
        
        lstm_layer = tf.nn.rnn_cell.DropoutWrapper(
	    cell=lstm_layer, input_keep_prob=1.0, output_keep_prob=keep_prob)

    return lstm_layer
    
        
def DNN_Layer(inputs, shape, layer_name):
    with tf.variable_scope(layer_name) as scope:
        W = tf.get_variable(layer_name + "w", shape=shape, initializer=tf.random_normal_initializer(mean=0, stddev=1),
                            dtype=tf.float32)
        out_dimension = shape[-1]
        b = tf.get_variable(layer_name + "b", shape=[out_dimension], initializer=tf.constant_initializer(0.1),
                            dtype=tf.float32)

    dnn_output = tf.nn.relu(tf.matmul(inputs, W) + b)
    return dnn_output

            

            
def get_checkpoint():
	with open("checkpoint.info", 'r') as f:
		checkpoint = f.readline()
	if checkpoint == '':
		return ''
	else:
		return checkpoint


def set_checkpoint(checkpoint):
	with open("checkpoint.info", 'w') as f:
		f.write(checkpoint)
	return

def one_hot_code(label, class_cnt, label_dict):
    one_hot = []
    label = label_dict[label]
    for i in range(class_cnt):
        value = 0
        if i == label:
            value = 1
        one_hot.append(value)
    return one_hot

def get_batch(dataManager, batch_size):
    batch_data, labels, seq_lengths, utt_list = dataManager.get_next_batch(batch_size)
    one_hot_labes = []
    for i in range(len(seq_lengths)):
        one_hot = one_hot_code(labels[i], FLAGS.softmax_size, label_dict)
        one_hot_labes.append(one_hot)

    return batch_data, one_hot_labes, seq_lengths, utt_list


def computeGraph(input_data, labels, seq_lengths):
        with tf.name_scope("compute_graph") as scope:
            with tf.name_scope("define_lstm_layer") as scope:
                lstm_layer_1 = LSTM_Layer(FLAGS.lstm_hidden_size, "lstm_layer_1", FLAGS.keep_prob)
                lstm_layer_2 = LSTM_Layer(FLAGS.lstm_hidden_size, "lstm_layer_2", FLAGS.keep_prob)

                multi_lstm_layer = tf.nn.rnn_cell.MultiRNNCell([lstm_layer_1, lstm_layer_2],
                                                               state_is_tuple=True)

            with tf.name_scope("input_data") as scope:
                print("Get there input")

            with tf.name_scope("lstm_init_state") as scope:
                cur_batch_size = input_data.shape[0]
                init_state = multi_lstm_layer.zero_state(cur_batch_size, dtype=tf.float32)  # init_state

            with tf.name_scope("run_lstm_through_time") as scope:
                every_time_outputs, state = tf.nn.dynamic_rnn(multi_lstm_layer,
                                                              inputs= input_data,
                                                              initial_state=init_state,
                                                              sequence_length=seq_lengths)

                cur_layer_output = state[-1][1]  # current layer output to next layer as input.

            with tf.name_scope("run_dnn_layer") as scope:
                # shape = [FLAGS.lstm_hidden_size, FLAGS.dnn_hidden_size]
                # cur_layer_output = DNN_Layer(cur_layer_output, shape, "dnn_layer_1")

                # shape = [FLAGS.dnn_hidden_size, FLAGS.dnn_hidden_size]
                # cur_layer_output = DNN_Layer(cur_layer_output, shape, "dnn_layer_2")

                # shape = [FLAGS.lstm_hidden_size, FLAGS.softmax_size]
                # cur_layer_output = DNN_Layer(cur_layer_output, shape, "dnn_layer_3")
                shape = [FLAGS.lstm_hidden_size, FLAGS.softmax_size]
                W = tf.get_variable("last_W", shape=shape, initializer=tf.random_normal_initializer(mean=0, stddev=1),
                            dtype=tf.float32)
                b = tf.get_variable("last_b", shape=FLAGS.softmax_size,
                                    initializer=tf.random_normal_initializer(mean=0, stddev=1), dtype=tf.float32)
                
                cur_layer_output = tf.matmul(cur_layer_output, W) + b
                
            with tf.name_scope("run_softmax") as scope:
                predict = tf.nn.softmax(cur_layer_output)

            with tf.name_scope("cross_entropy"):
                cross_entropy = -tf.reduce_mean(labels * tf.log(predict))
                #cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=labels, logits=predict))

            return predict, cross_entropy


def average_gradients(tower_grads):
    """Calculate average gradient for each shared variable across all towers.
    Note that this function provides a synchronization point across all towers.
    Args:
      tower_grads: List of lists of (gradient, variable) tuples. The outer list
        is over individual gradients. The inner list is over the gradient
        calculation for each tower.
    Returns:
       List of pairs of (gradient, variable) where the gradient has been
       averaged across all towers.
    """
    average_grads = []
    for grad_and_vars in zip(*tower_grads):
        # Note that each grad_and_vars looks like the following:
        #   ((grad0_gpu0, var0_gpu0), ... , (grad0_gpuN, var0_gpuN))
        grads = []
        for g, _ in grad_and_vars:
            # Add 0 dimension to the gradients to represent the tower.
            expanded_g = tf.expand_dims(g, 0)

            # Append on a 'tower' dimension which we will average over below.
            grads.append(expanded_g)

        # Average over the 'tower' dimension.
        grad = tf.concat(grads, 0)
        grad = tf.reduce_mean(grad, 0)

        # Keep in mind that the Variables are redundant because they are shared
        # across towers. So .. we will just return the first tower's pointer to
        # the Variable.
        v = grad_and_vars[0][1]
        grad_and_var = (grad, v)
        average_grads.append(grad_and_var)
    return average_grads
    

def TensorBoardSummary(summaries, doSummary, grads, lr):
    if doSummary:
        # For TensorBoard Debugging
        if FLAGS.tb_logging:
            # for all variables's gradients 
            for grad, var in grads:
                if grad is not None:
                    summaries.append(tf.summary.histogram(var.op.name + '/gradients', grad))

            # Add a summary to track the learning rate.
            summaries.append(tf.summary.scalar('learning_rate', lr))
            
            # for all train variables 
            for var in tf.trainable_variables():
                summaries.append(tf.summary.histogram(var.op.name, var))
                
        summary_op = tf.summary.merge(summaries)        
        return summary_op


class languageRecGraph(object):

    def __init__(self):
        # DEFINE THE GRAPH
        with tf.device("/cpu:0"):

            # ==================================
            # DEFINE INPUT PART OF  GRAPH
            # ==================================
            self.Train_X = tf.placeholder(tf.float32, [FLAGS.batch_size * FLAGS.num_gpus, None, FLAGS.feature_size])
            self.Train_Y = tf.placeholder(tf.float32, [FLAGS.batch_size * FLAGS.num_gpus, FLAGS.softmax_size])
            self.Train_Seq = tf.placeholder(tf.int32, [FLAGS.batch_size * FLAGS.num_gpus])


            # the num of batchs processed * num_gpus
            global_steps = tf.get_variable("global_step", [],
                                           initializer=tf.constant_initializer(0), trainable=False)
            with tf.name_scope("Optimizer"):
                # # Decay the learning rate exponentially based on the number of steps.
                lr = tf.train.exponential_decay(INITIAL_LEARNING_RATE,
                                                global_steps,
                                                FLAGS.decay_step,
                                                LEARNING_RATE_DECAY_FACTOR,
                                                staircase=True)

                Optimizer = tf.train.MomentumOptimizer(lr, 0.9, use_nesterov=True, use_locking=True)
                # Optimizer = tf.train.AdamOptimizer(0.1)
                # Optimizer = tf.train.GradientDescentOptimizer(0.1)
            # ==================================
            # DEFINE MULTI GPU COMPUTE PART OF GRAPH
            # ==================================
            # interval = self.Train_X.get_shape()[0] // FLAGS.num_gpus
            # print(self.Train_X.get_shape)
            batch_list = []
            for i in range(FLAGS.num_gpus):
                batch_list.append(FLAGS.batch_size*i)
            batch_list.append(FLAGS.batch_size * FLAGS.num_gpus)

            tower_grads = []
            self.tower_predict = []
            self.tower_loss = []
            with tf.variable_scope(tf.get_variable_scope()):
                for i in range(FLAGS.num_gpus):
                    with tf.device('/gpu:%d' % i):
                        with tf.name_scope('tower_%d' % i) as scope:
                            # shape: [batch_size x None x feature_size]
                            # : [batch_size x softmax_size]
                            # : [batch_size]

                            input_data = self.Train_X[batch_list[i]: batch_list[i+1]]
                            labels = self.Train_Y[batch_list[i]: batch_list[i+1]]
                            seq_len = self.Train_Seq[batch_list[i]: batch_list[i+1]]

                            # Forward Propagate and Compute loss
                            predict, loss = computeGraph(input_data, labels, seq_len)
                            # Backward Propagate
                            #     The backward propagate should use all the grads through gpu,
                            #     so run at jump out the for i in num_gpus
                            summaries = tf.get_collection(tf.GraphKeys.SUMMARIES, scope)

                            # Compute the current Thread gradient
                            grads = Optimizer.compute_gradients(loss)
                            tower_grads.append(grads)
                            self.tower_predict.append(predict)
                            self.tower_loss.append(loss)
                            # reuse variable for next thread.
                            tf.get_variable_scope().reuse_variables()



            # ==================================
            # DEFINE MERGE THE MULTI GPU COMPUTE
            # ==================================

            # should use the synchronization point across all Thread, average the grads,
            # to update all variables
            grads = average_gradients(tower_grads)

            update_ops = tf.get_collection(tf.GraphKeys.UPDATE_OPS)
            with tf.control_dependencies(update_ops):
                # This is a update operate, this will increment the global_step,
                self.train_op = Optimizer.apply_gradients(grads, global_step=global_steps)


            # ==================================
            # DEFINE THE SAVER OF GRAPH
            # ==================================

            # define a save for all the variabels define above.
            self.saver = tf.train.Saver(tf.global_variables(), sharded=True)

            # summary_op = TensorBoardSummary(summaries, FLAGS.tb_logging, grads, lr)


class mnistRecGraph(object):

    def __init__(self):
        # DEFINE THE GRAPH
        with tf.device("/cpu:0"):

            # ==================================
            # DEFINE INPUT PART OF  GRAPH
            # ==================================
            self.Train_X = tf.placeholder(tf.float32, [FLAGS.batch_size * FLAGS.num_gpus, None, FLAGS.feature_size])
            self.Train_Y = tf.placeholder(tf.float32, [FLAGS.batch_size * FLAGS.num_gpus, FLAGS.softmax_size])
            self.Train_Seq = tf.placeholder(tf.int32, [FLAGS.batch_size * FLAGS.num_gpus])

            # the num of batchs processed * num_gpus
            global_steps = tf.get_variable("global_step", [],
                                           initializer=tf.constant_initializer(0), trainable=False)
            with tf.name_scope("Optimizer"):
                # # Decay the learning rate exponentially based on the number of steps.
                lr = tf.train.exponential_decay(INITIAL_LEARNING_RATE,
                                                global_steps,
                                                FLAGS.decay_step,
                                                LEARNING_RATE_DECAY_FACTOR,
                                                staircase=True)

                Optimizer = tf.train.MomentumOptimizer(lr, 0.9, use_nesterov=True, use_locking=True)
                # Optimizer = tf.train.AdamOptimizer(0.1)
                # Optimizer = tf.train.GradientDescentOptimizer(0.1)
            # ==================================
            # DEFINE MULTI GPU COMPUTE PART OF GRAPH
            # ==================================
            # interval = self.Train_X.get_shape()[0] // FLAGS.num_gpus
            # print(self.Train_X.get_shape)
            batch_list = []
            for i in range(FLAGS.num_gpus):
                batch_list.append(FLAGS.batch_size * i)
            batch_list.append(FLAGS.batch_size * FLAGS.num_gpus)

            tower_grads = []
            self.tower_predict = []
            self.tower_loss = []
            with tf.variable_scope(tf.get_variable_scope()):
                for i in range(FLAGS.num_gpus):
                    with tf.device('/cpu:%d' % i):
                        with tf.name_scope('tower_%d' % i) as scope:
                            # shape: [batch_size x None x feature_size]
                            # : [batch_size x softmax_size]
                            # : [batch_size]

                            input_data = self.Train_X[batch_list[i]: batch_list[i + 1]]
                            labels = self.Train_Y[batch_list[i]: batch_list[i + 1]]
                            seq_len = self.Train_Seq[batch_list[i]: batch_list[i + 1]]

                            # Forward Propagate and Compute loss
                            predict, loss = computeGraph(input_data, labels, seq_len)
                            # Backward Propagate
                            #     The backward propagate should use all the grads through gpu,
                            #     so run at jump out the for i in num_gpus
                            summaries = tf.get_collection(tf.GraphKeys.SUMMARIES, scope)

                            # Compute the current Thread gradient
                            grads = Optimizer.compute_gradients(loss)
                            tower_grads.append(grads)
                            self.tower_predict.append(predict)
                            self.tower_loss.append(loss)
                            # reuse variable for next thread.
                            tf.get_variable_scope().reuse_variables()

            # ==================================
            # DEFINE MERGE THE MULTI GPU COMPUTE
            # ==================================

            # should use the synchronization point across all Thread, average the grads,
            # to update all variables
            grads = average_gradients(tower_grads)

            update_ops = tf.get_collection(tf.GraphKeys.UPDATE_OPS)
            with tf.control_dependencies(update_ops):
                # This is a update operate, this will increment the global_step,
                self.train_op = Optimizer.apply_gradients(grads, global_step=global_steps)

            # ==================================
            # DEFINE THE SAVER OF GRAPH
            # ==================================

            # define a save for all the variabels define above.
            self.saver = tf.train.Saver(tf.global_variables(), sharded=True)

            # summary_op = TensorBoardSummary(summaries, FLAGS.tb_logging, grads, lr)

    #
    # # Start running operations on the Graph. allow_soft_placement must be
    # # set to True to build towers on GPU, as some of the ops do not have GPU
    # # implementations.
    # sess = tf.Session(config=tf.ConfigProto(allow_soft_placement=True,
    #                                         log_device_placement=FLAGS.log_device_placement))

def train(model, sess):
    log = getLogger()
    # ==================================
    # RUN THE GRAPH
    # ==================================

    # summary_writer = tf.summary.FileWriter(FLAGS.train_dir, sess.graph)
    for current_step in range(FLAGS.max_train_step):
        start_time = time.time()
        Multi_gpu_batch_x, Multi_gpu_batch_y = mnist.train.next_batch(FLAGS.batch_size * FLAGS.num_gpus)
        Multi_gpu_batch_x= Multi_gpu_batch_x.reshape([40, 28, 28])
        print(Multi_gpu_batch_x.shape)
        seq_lengths = []
        for i in range(FLAGS.batch_size * FLAGS.num_gpus):
            seq_lengths.append(28)

        batch_train_data={
            model.Train_X:Multi_gpu_batch_x,
            model.Train_Y:Multi_gpu_batch_y,
            model.Train_Seq:seq_lengths
        }

        _, predict, loss_value = sess.run([model.train_op, model.tower_predict, model.tower_loss],
                                          feed_dict=batch_train_data)

        duration = time.time() - start_time
        # assert not np.isnan(loss_value), 'Model diverged with loss = NaN'

        print(Multi_gpu_batch_x[0][0])
        print(seq_lengths[0])
        print(Multi_gpu_batch_y[0])
        print(predict[0][0])
        print(loss_value[0])
        
        print("Training Step:{0},loss:{1}".format(
                current_step, loss_value[-1]))

        if (current_step % FLAGS.checkpoint_interval) == 0:
            path = model.saver.save(sess, "./models/model-{}.ckpt".format(current_step))
            set_checkpoint(path)
            log.info("Checkpoint saved {}".format(path))

        if (current_step + 1) == FLAGS.max_train_step:
            path = model.saver.save(sess, "./models/final-model-ckpt")
            set_checkpoint(path)
            log.info("Checkpoint saved {}".format(path))


def test(session, model):
	log = getLogger()
	acc = []
	# merged = tf.summary.merge_all()
	# test_writer = tf.summary.FileWriter('./testSummary')

	# for i in range((test_data.shape[0]//20)+1):
	# 	sequence_lenths, batch_data, batch_label = get_batch()
    #
	# 	feed_dict = {model.input_data: batch_data,
    #                          model.labels: batch_label,
    #                          model.keep_prob: 1.0,
    #                          model.learning_rate: 0,
    #                          model.squence_lenths: sequence_lenths}
    #
	# 	accuracy = session.run([model.accuracy], feed_dict)


	# accuracy = np.mean(acc)
	# log.info("Test Accuracy:{}".format(accuracy))
	return log, acc

#
# def prediction(session, config, model, sample_data, label_dict):
# 	log = getLogger()
# 	sample_batch = [sample_data for i in range(config.batch_size)]
# 	sequence_lenths = [sample_data.shape[0] for i in range(config.batch_size)]
# 	batch_label = np.ndarray([config.batch_size,config.language_class_count])
# 	feed_dict = {
#                 model.input_data: sample_batch,
#                 model.labels:batch_label,
#                 model.keep_prob: 1.0,
#                 model.learning_rate: 0,
#                 model.squence_lenths: sequence_lenths
#         }
#
# 	final_state,prediction = session.run([model.final_state,model.prediction], feed_dict)
# 	print(prediction)
#
# 	i = prediction[0]
# 	log.info("Prediction:{},{}".format(label_dict[i], i))
# 	print("Prediction:{},{}".format(label_dict[i], i))
# 	print("FinalState:",final_state[0])
# 	return


if __name__ == '__main__':
    log = getLogger()
    session_config = tf.ConfigProto(
        allow_soft_placement=True, log_device_placement=False)

    with tf.Graph().as_default():
        with tf.device("/gpu:0"):
            model = languageRecGraph()

        with tf.Session(config=session_config) as session:
            session.run(tf.global_variables_initializer())

            if working_type == 1:
                train(model, session)
            elif working_type == 2:
                test(model, session)
