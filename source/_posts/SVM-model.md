title: SVM数学推导
categories:
  - 学习笔记
tags:
  - SVM
date: 2014-07-12 00:00:00
---

## 最优间隔分类器
针对模式分类问题，通过特征提取后，就能得到特征向量及对应的类别标签：

{% math-block %}
( {\vec x}_i, y_i ), \quad i=1,2,3 \cdots m
{% endmath-block %}

其中，{% math {\vec x}_i %}表示第i个样本的特征向量，{% math y_i %} 表示第i个样本所属类别。

对于二分类问题，设线性分类器的判别函数为 {% math d({\vec x})={\vec w} \cdot {\vec x}+b %} ，对于一个待分类样本，通过特征提取得到其特征向量，将特征向量代入分类器判别函数，若输出为正，则将样本判定为+1类，否则为-1类。从几何的观点来看，特征提取是将样本抽象为欧氏空间中的一个点，而判别函数是该空间中的一个超平面，超平面不同侧的点对应不同类别的样本。因此，如果样本线性可分的话，那么就存在无穷多个超平面将其分开，也即存在无穷多个线性分类器能将样本分开，既然是这样，那么哪一个最好呢？直观上看，应该使分类超平面离样本点越远越好，这样可以减小把新样本分错的概率。当然，此处的“越远越好”的前提是要正确分类。分类器的间隔定义为所有样本点到分类超平面的距离中的最小值。最优间隔分类器就是间隔最大的分类器。

样本点{% math {\vec x}_i %}到超平面的距离为：

{% math-block %}
\frac{|\vec w \cdot {\vec x}_i + b|}{\Vert \vec w \Vert}
{% endmath-block %}

最优间隔分类器的优化目标为：

{% math-block %}
\mathop{max}_{\vec w, b} \{ \mathop{min}_i \{ \frac{|\vec w \cdot {\vec x}_i + b|}{\Vert \vec w \Vert} \} \}
{% endmath-block %}

要直接求解上述优化问题显然不易，然而，幸运的是可以将其转化为一个凸优化问题。

## 转化为带约束的凸优化问题
上一节将最优间隔分类器的求解转化为一个数学优化问题，我们最终的目标是求得{% math \vec w %}和{% math b %}，如果{% math \vec w^* %}和{% math b^* %}是最优间隔分类器的参数，那么{% math k\cdot {\vec w}^* %}和{% math k\cdot b^* %}其实对应同一个分类器(超平面)。由此可以得出，在问题可分的情况下，一定存在{% math \vec w %}和{% math b %}满足{% math |\vec w \cdot {\vec x}_i + b| \geq 1 %}，同时又是最优间隔分类器的参数。因此可以考虑把这个约束加到上一节的优化问题中，关键在于，加入此约束后，求得的最优解与原问题等价，同时可以将原问题简化。下面看看如何简化：
{% math-block %}
\begin{eqnarray}
&& \mathop{max}_{\vec w, b} \{ \mathop{min}_i \{ \frac{|\vec w \cdot {\vec x}_i + b|}{\Vert \vec w \Vert} \} \} , & s.t. \quad  |\vec w \cdot {\vec x}_i + b| \geq 1 \\
& \Leftrightarrow 
& \mathop{max}_{\vec w, b} \{ \frac{1}{\Vert \vec w \Vert} \} , & s.t. \quad  |\vec w \cdot {\vec x}_i + b| \geq 1 \\
& \Leftrightarrow 
& \mathop{min}_{\vec w, b}  {\Vert \vec w \Vert} , & s.t. \quad  |\vec w \cdot {\vec x}_i + b| \geq 1 \\
& \Leftrightarrow 
& \mathop{min}_{\vec w, b}  \frac{1}{2}{\Vert \vec w \Vert}^2  , & s.t. \quad  |\vec w \cdot {\vec x}_i + b| \geq 1 \\
& \Leftrightarrow 
& \mathop{min}_{\vec w, b}  \frac{1}{2}{\Vert \vec w \Vert}^2  , & s.t. \quad  (\vec w \cdot {\vec x}_i + b)\cdot y_i \geq 1 
\end{eqnarray}
{% endmath-block %}
最终，我们将上一节复杂的优化问题转化成了一个带约束的凸优化问题，但仍然不好求解，所以还得转化。

## 转化为对偶问题
为了得到对偶问题，先构造罚函数{% math L(\vec w, b, \vec \alpha) %}，然后分析{% math \mathop{max}_{\vec w, b} \{ \mathop{min}_{\vec \alpha} L(\vec w, b, \vec \alpha) \} %}与上一节的带约束凸优化问题等价，接着根据对偶原理将max min问题转化为min max问题：{% math \mathop{min}_{\vec \alpha} \{ \mathop{max}_{\vec w, b} L(\vec w, b, \vec \alpha) \} %}。

### 罚函数的构造
罚函数的思想是把约束条件吸收到目标函数里面，通过增加目标函数的参数来减少约束条件，同时为了保证罚函数与原优化问题等价，往往需要引入新的约束，但新的约束条件通常较简单。在此引入的罚函数为：
{% math-block %}
\begin{align}
& L(\vec w, b, \vec \alpha)=\frac{1}{2}{\Vert \vec w \Vert}^2 - \sum_{i} \alpha_i [(\vec w \cdot {\vec x}_i + b)\cdot y_i - 1 ] \\
& s.t. \quad \alpha_i \geq 0 
\end{align}
{% endmath-block %}

### 等价性分析
现在来分析{% math \mathop{min}_{\vec w, b} \{ \mathop{max}_{\vec \alpha} L(\vec w, b, \vec \alpha) \} %}与上一节的带约束凸优化问题等价。为了便于分析min max函数的值，先把参数空间划分为2个子集合，不妨叫集合A和集合B，集合A中的参数满足{% math (\vec w \cdot {\vec x}_i)\cdot y_i - 1 \geq 0 %}，B为A的补集，然后进行如下推导：
{% math-block %}
\begin{eqnarray}
&& \mathop{min}_{\vec w, b} \{ \mathop{max}_{\vec \alpha \geq 0 } L(\vec w, b, \vec \alpha) \} \\
&=& \mathop{min}_{\vec w, b} \{ \mathop{max}_{\vec \alpha \geq 0, (\vec w, b)\in A } L(\vec w, b, \vec \alpha), \mathop{max}_{\vec \alpha \geq 0 , (\vec w, b)\in B } L(\vec w, b, \vec \alpha) \}  \\
&=& \mathop{min}_{\vec w, b} \{ { \frac{1}{2}{\Vert \vec w \Vert}^2 }_{ (\vec w, b)\in A }, { \frac{1}{2}{\Vert \vec w \Vert}^2 }_{ (\vec w, b)\in B } + \infty \}  \\
&=& \mathop{min}_{\vec w, b}_{ (\vec w, b)\in A }  \frac{1}{2}{\Vert \vec w \Vert}^2  
\end{eqnarray}
{% endmath-block %}
推导结果表面min max函数与上一节中带约束的凸优化问题是等价的。

### 将min max函数转为max min函数
貌似在满足一定的条件下，min max函数和max min函数在相同点取得最优解，也即：
{% math-block %}
\begin{eqnarray}
&& \mathop{min}_{\vec w, b} \{ \mathop{max}_{\vec \alpha} L(\vec w, b, \vec \alpha) \} \\
&=& \mathop{max}_{\vec \alpha} \{ \mathop{min}_{\vec w, b} L(\vec w, b, \vec \alpha) \} 
\end{eqnarray}
{% endmath-block %}

## 求解对偶问题
先对内层min函数求一阶必要性条件：
{% math-block %}
\begin{align}
& \frac{\partial L }{\vec w} = \vec w - \sum_{i} \alpha_i y_i {\vec x}_i = 0 \\
& \frac{\partial L }{b} = \sum_{i} \alpha_i y_i = 0 
\end{align}
{% endmath-block %}
可得{% math \vec w = \sum_{i} \alpha_i y_i {\vec x}_i %}，代入对偶问题中可得：
{% math-block %}
\begin{align}
& \mathop{max}_{\vec \alpha} \{ \mathop{min}_{\vec w, b} L(\vec w, b, \vec \alpha) \} 
= \mathop{max}_{\vec \alpha} \{ \sum_{i} \alpha_i - \sum_{i,j} \alpha_i \alpha_j y_i y_j {\vec x}_i {\vec x}_j \} \\
& s.t. \quad \sum_{i} \alpha_i y_i = 0 
\end{align}
{% endmath-block %}
转化成上述形式后可通过SMO算法快速求得最优解。关于SMO算法，打算单独写一篇。
