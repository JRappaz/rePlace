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
q#X   140582967151328q$X   cpuq%KHNtq&QK KK�q'KK�q(tq)Rq*�q+Rq,��N�q-bX   biasq.h h!((h"h#X   140583250110704q/h%KNtq0QK K�q1K�q2tq3Rq4�q5Rq6��N�q7buhh)Rq8hh)Rq9hh)Rq:hh)Rq;hh)Rq<X   trainingq=�X   in_featuresq>KX   out_featuresq?KubX   1q@(h ctorch.nn.modules.batchnorm
BatchNorm1d
qAX�   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/batchnorm.pyqBX�  class BatchNorm1d(_BatchNorm):
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
qCtqDQ)�qE}qF(hh	h
h)RqG(hh h!((h"h#X   140582967162288qHh%KNtqIQK K�qJK�qKtqLRqM�qNRqO��N�qPbh.h h!((h"h#X   140582967140496qQh%KNtqRQK K�qSK�qTtqURqV�qWRqX��N�qYbuhh)RqZ(X   running_meanq[h!((h"h#X   140583250115040q\h%KNtq]QK K�q^K�q_tq`RqaX   running_varqbh!((h"h#X   140583250098256qch%KNtqdQK K�qeK�qftqgRqhuhh)Rqihh)Rqjhh)Rqkhh)Rqlh=�X   num_featuresqmKX   affineqn�X   epsqoG>�����h�X   momentumqpG?�������ubX   2qqh)�qr}qs(hh	h
h)Rqt(hh h!((h"h#X   140582967100384quh%KNtqvQK KK�qwKK�qxtqyRqz�q{Rq|��N�q}bh.h h!((h"h#X   140583250125984q~h%KNtqQK K�q�K�q�tq�Rq��q�Rq���N�q�buhh)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�h=�h>Kh?KubX   3q�(h ctorch.nn.modules.activation
Sigmoid
q�X�   /usr/local/Cellar/python3/3.6.3/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/torch/nn/modules/activation.pyq�X3  class Sigmoid(Module):
    r"""Applies the element-wise function :math:`f(x) = 1 / ( 1 + exp(-x))`

    Shape:
        - Input: :math:`(N, *)` where `*` means, any number of additional
          dimensions
        - Output: :math:`(N, *)`, same shape as the input

    Examples::

        >>> m = nn.Sigmoid()
        >>> input = autograd.Variable(torch.randn(2))
        >>> print(input)
        >>> print(m(input))
    """

    def forward(self, input):
        return torch.sigmoid(input)

    def __repr__(self):
        return self.__class__.__name__ + '()'
q�tq�Q)�q�}q�(hh	h
h)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�h=�ubuh=�ub.�]q (X   140582967100384qX   140582967140496qX   140582967151328qX   140582967162288qX   140583250098256qX   140583250110704qX   140583250115040qX   140583250125984qe.       ��='�>[�>f�>�%>���N�}>���ڹ�>�-�>O1>j�q>       �/�=�t��Uٽ���0D��g�=LӼN�u<np������Z������H       ��c�����x�0��=w�����^�9�>)����=w� �m����=Tد���>��w=ҵ-���=>>�듾�蝾�+H�&��s�a��¾�S���#�>|�V>������Ҽ�_��վƙ����=�"����6�Lr>���>�'����>�Ʒ�3�G��U3>�߄���<��<>q���3�=J���귾�\�>� 4=0��M�h�=�v	?.�=E8y���=��3n�e=a����౾���=�P1�5K���c�r+c>�ӫ��r>w�/��~��Θ�<       }�4?R1F?ݪ-?ӛ>�� ?-,u?˓�>5��>��?R�?��>��>       3`0<!4<UA+<�8K<�>o<A��<���;O3x;vcK<��t<�<;�s;       &:�����=b�=\=�n��L�潃������\���A��k�=+�       z�T��>|�=�H��	1�Ek���*;4j������T���H=�C>       �%�