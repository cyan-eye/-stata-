cd F:\框艳论文修改\空间计量模型\莫兰指数
use "所有变量.dta" ,clear

preserve
keep if year == 2015
*更改空间权重矩阵
spatwmat using W300.dta, name(W) standardize

*全局检验
spatgsa GF, weights(W) moran geary

*局部并绘图
*spatlsa ICM, weights(W) moran graph(moran) symbol(n)
restore

