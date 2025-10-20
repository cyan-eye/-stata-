* 声明面板数据结构
xtset id year

* 2SLS 固定效应估计，全部解释变量一期滞后为工具变量
xtivreg2 ICM (GF = L.GF) lngdp FD FDI lnhc, fe first cluster(id)
