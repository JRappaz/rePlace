��
l��F� j�P.�M�.�}q (X   protocol_versionqM�X   little_endianq�X
   type_sizesq}q(X   shortqKX   intqKX   longqKuu.�(X   moduleq ctorch.nn.modules.container
Sequential
qX�   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/container.pyqXn  class Sequential(Module):
    r"""A sequential container.
    Modules will be added to it in the order they are passed in the constructor.
    Alternatively, an ordered dict of modules can also be passed in.

    To make it easier to understand, given is a small example::

        # Example of using Sequential
        model = nn.Sequential(
                  nn.Conv2d(1,20,5),
                  nn.ReLU(),
                  nn.Conv2d(20,64,5),
                  nn.ReLU()
                )

        # Example of using Sequential with OrderedDict
        model = nn.Sequential(OrderedDict([
                  ('conv1', nn.Conv2d(1,20,5)),
                  ('relu1', nn.ReLU()),
                  ('conv2', nn.Conv2d(20,64,5)),
                  ('relu2', nn.ReLU())
                ]))
    """

    def __init__(self, *args):
        super(Sequential, self).__init__()
        if len(args) == 1 and isinstance(args[0], OrderedDict):
            for key, module in args[0].items():
                self.add_module(key, module)
        else:
            for idx, module in enumerate(args):
                self.add_module(str(idx), module)

    def __getitem__(self, idx):
        if not (-len(self) <= idx < len(self)):
            raise IndexError('index {} is out of range'.format(idx))
        if idx < 0:
            idx += len(self)
        it = iter(self._modules.values())
        for i in range(idx):
            next(it)
        return next(it)

    def __len__(self):
        return len(self._modules)

    def forward(self, input):
        for module in self._modules.values():
            input = module(input)
        return input
qtqQ)�q}q(X   _backendqctorch.nn.backends.thnn
_get_thnn_function_backend
q)Rq	X   _parametersq
ccollections
OrderedDict
q)RqX   _buffersqh)RqX   _backward_hooksqh)RqX   _forward_hooksqh)RqX   _forward_pre_hooksqh)RqX   _modulesqh)Rq(X   0q(h ctorch.nn.modules.linear
Linear
qX   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/linear.pyqXs  class Linear(Module):
    r"""Applies a linear transformation to the incoming data: :math:`y = Ax + b`

    Args:
        in_features: size of each input sample
        out_features: size of each output sample
        bias: If set to False, the layer will not learn an additive bias.
            Default: ``True``

    Shape:
        - Input: :math:`(N, *, in\_features)` where `*` means any number of
          additional dimensions
        - Output: :math:`(N, *, out\_features)` where all but the last dimension
          are the same shape as the input.

    Attributes:
        weight: the learnable weights of the module of shape
            (out_features x in_features)
        bias:   the learnable bias of the module of shape (out_features)

    Examples::

        >>> m = nn.Linear(20, 30)
        >>> input = autograd.Variable(torch.randn(128, 20))
        >>> output = m(input)
        >>> print(output.size())
    """

    def __init__(self, in_features, out_features, bias=True):
        super(Linear, self).__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.weight = Parameter(torch.Tensor(out_features, in_features))
        if bias:
            self.bias = Parameter(torch.Tensor(out_features))
        else:
            self.register_parameter('bias', None)
        self.reset_parameters()

    def reset_parameters(self):
        stdv = 1. / math.sqrt(self.weight.size(1))
        self.weight.data.uniform_(-stdv, stdv)
        if self.bias is not None:
            self.bias.data.uniform_(-stdv, stdv)

    def forward(self, input):
        return F.linear(input, self.weight, self.bias)

    def __repr__(self):
        return self.__class__.__name__ + '(' \
            + 'in_features=' + str(self.in_features) \
            + ', out_features=' + str(self.out_features) \
            + ', bias=' + str(self.bias is not None) + ')'
qtqQ)�q}q(hh	h
h)Rq(X   weightqctorch.nn.parameter
Parameter
q ctorch._utils
_rebuild_tensor
q!((X   storageq"ctorch
FloatStorage
q#X   140582967128112q$X   cpuq%KHNtq&QK KK�q'KK�q(tq)Rq*�q+Rq,��N�q-bX   biasq.h h!((h"h#X   140582967130464q/h%KNtq0QK K�q1K�q2tq3Rq4�q5Rq6��N�q7buhh)Rq8hh)Rq9hh)Rq:hh)Rq;hh)Rq<X   trainingq=�X   in_featuresq>KX   out_featuresq?KubX   1q@(h ctorch.nn.modules.activation
ReLU
qAX�   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/activation.pyqBX  class ReLU(Threshold):
    r"""Applies the rectified linear unit function element-wise
    :math:`{ReLU}(x)= max(0, x)`

    Args:
        inplace: can optionally do the operation in-place. Default: ``False``

    Shape:
        - Input: :math:`(N, *)` where `*` means, any number of additional
          dimensions
        - Output: :math:`(N, *)`, same shape as the input

    Examples::

        >>> m = nn.ReLU()
        >>> input = autograd.Variable(torch.randn(2))
        >>> print(input)
        >>> print(m(input))
    """

    def __init__(self, inplace=False):
        super(ReLU, self).__init__(0, 0, inplace)

    def __repr__(self):
        inplace_str = 'inplace' if self.inplace else ''
        return self.__class__.__name__ + '(' \
            + inplace_str + ')'
qCtqDQ)�qE}qF(hh	h
h)RqGhh)RqHhh)RqIhh)RqJhh)RqKhh)RqLh=�X	   thresholdqMK X   valueqNK X   inplaceqO�ubX   2qP(h ctorch.nn.modules.dropout
Dropout
qQX�   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/dropout.pyqRX  class Dropout(Module):
    r"""During training, randomly zeroes some of the elements of the input
    tensor with probability *p* using samples from a bernoulli distribution.
    The elements to zero are randomized on every forward call.

    This has proven to be an effective technique for regularization and
    preventing the co-adaptation of neurons as described in the paper
    `Improving neural networks by preventing co-adaptation of feature
    detectors`_ .

    Furthermore, the outputs are scaled by a factor of *1/(1-p)* during
    training. This means that during evaluation the module simply computes an
    identity function.

    Args:
        p: probability of an element to be zeroed. Default: 0.5
        inplace: If set to ``True``, will do this operation in-place. Default: ``False``

    Shape:
        - Input: `Any`. Input can be of any shape
        - Output: `Same`. Output is of the same shape as input

    Examples::

        >>> m = nn.Dropout(p=0.2)
        >>> input = autograd.Variable(torch.randn(20, 16))
        >>> output = m(input)

    .. _Improving neural networks by preventing co-adaptation of feature
        detectors: https://arxiv.org/abs/1207.0580
    """

    def __init__(self, p=0.5, inplace=False):
        super(Dropout, self).__init__()
        if p < 0 or p > 1:
            raise ValueError("dropout probability has to be between 0 and 1, "
                             "but got {}".format(p))
        self.p = p
        self.inplace = inplace

    def forward(self, input):
        return F.dropout(input, self.p, self.training, self.inplace)

    def __repr__(self):
        inplace_str = ', inplace' if self.inplace else ''
        return self.__class__.__name__ + '(' \
            + 'p=' + str(self.p) \
            + inplace_str + ')'
qStqTQ)�qU}qV(hh	h
h)RqWhh)RqXhh)RqYhh)RqZhh)Rq[hh)Rq\h=�X   pq]G?�      hO�ubX   3q^(h ctorch.nn.modules.batchnorm
BatchNorm1d
q_X�   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/batchnorm.pyq`X�  class BatchNorm1d(_BatchNorm):
    r"""Applies Batch Normalization over a 2d or 3d input that is seen as a
    mini-batch.

    .. math::

        y = \frac{x - mean[x]}{ \sqrt{Var[x] + \epsilon}} * gamma + beta

    The mean and standard-deviation are calculated per-dimension over
    the mini-batches and gamma and beta are learnable parameter vectors
    of size C (where C is the input size).

    During training, this layer keeps a running estimate of its computed mean
    and variance. The running sum is kept with a default momentum of 0.1.

    During evaluation, this running mean/variance is used for normalization.

    Because the BatchNorm is done over the `C` dimension, computing statistics
    on `(N, L)` slices, it's common terminology to call this Temporal BatchNorm

    Args:
        num_features: num_features from an expected input of size
            `batch_size x num_features [x width]`
        eps: a value added to the denominator for numerical stability.
            Default: 1e-5
        momentum: the value used for the running_mean and running_var
            computation. Default: 0.1
        affine: a boolean value that when set to ``True``, gives the layer learnable
            affine parameters. Default: ``True``

    Shape:
        - Input: :math:`(N, C)` or :math:`(N, C, L)`
        - Output: :math:`(N, C)` or :math:`(N, C, L)` (same shape as input)

    Examples:
        >>> # With Learnable Parameters
        >>> m = nn.BatchNorm1d(100)
        >>> # Without Learnable Parameters
        >>> m = nn.BatchNorm1d(100, affine=False)
        >>> input = autograd.Variable(torch.randn(20, 100))
        >>> output = m(input)
    """

    def _check_input_dim(self, input):
        if input.dim() != 2 and input.dim() != 3:
            raise ValueError('expected 2D or 3D input (got {}D input)'
                             .format(input.dim()))
        super(BatchNorm1d, self)._check_input_dim(input)
qatqbQ)�qc}qd(hh	h
h)Rqe(hh h!((h"h#X   140582967543760qfh%KNtqgQK K�qhK�qitqjRqk�qlRqm��N�qnbh.h h!((h"h#X   140582967269360qoh%KNtqpQK K�qqK�qrtqsRqt�quRqv��N�qwbuhh)Rqx(X   running_meanqyh!((h"h#X   140582967521296qzh%KNtq{QK K�q|K�q}tq~RqX   running_varq�h!((h"h#X   140582967527584q�h%KNtq�QK K�q�K�q�tq�Rq�uhh)Rq�hh)Rq�hh)Rq�hh)Rq�h=�X   num_featuresq�KX   affineq��X   epsq�G>�����h�X   momentumq�G?�������ubX   4q�h)�q�}q�(hh	h
h)Rq�(hh h!((h"h#X   140583250132544q�h%KNtq�QK KK�q�KK�q�tq�Rq��q�Rq���N�q�bh.h h!((h"h#X   140582967202048q�h%KNtq�QK K�q�K�q�tq�Rq��q�Rq���N�q�buhh)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�h=�h>Kh?KubX   5q�hA)�q�}q�(hh	h
h)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�h=�hMK hNK hO�ubuh=�ub.�]q (X   140582967128112qX   140582967130464qX   140582967202048qX   140582967269360qX   140582967521296qX   140582967527584qX   140582967543760qX   140583250132544qe.H       �&�<<B<�z��mZ:��Ȼ	�T�?»m\;��:�|�;�՗���K�U�9;�w:�&�E᛺T����Ż�n�t6M�﹂�!���n.;�O�͑�<8��<h:��P
���ȑ��
�E/�:(�;�˫�>��;�R�;�����<Ң%<oIʽ�c;�̔�9��@�~�S	>��6��I�{�6sA=ֱ�;w7�;﷬<���Yw�9�=������d�E��� �ջ�WлYra;�������}������*?��>)����;D��5V��:�c:�l�Y��;       �*ü󇻘o ���9f���B��{kݽ)��=�lüM^���������       F)��          ��j4     �        �TtM-           �       �_2��1   �j|-3��2��.   {5���1                �#�.y�3-   �yI't��/R>�(    m�3�}�-                ��A<%p�;���;\o<�!<)r+<J=�<�ii>��<� �<�K�g�;          ���     �     �   �í     �     �