clear
cd "F:\框艳论文修改\空间计量模型\空间计量"

**LM检验
*1.扩大年份（14倍）
use "W01.dta"
spcs2xt a1-a156,matrix(aaa)time(14)
spatwmat using aaaxt,name(W) standardize

*2.执行代码
use "所有变量.dta"
xtset id year 
reg ICM GF lngdp FD FDI lnhc
spatdiag,weights(W)
eststo model1

clear
cd "F:\框艳论文修改\空间计量模型\空间计量"
spatwmat using W50,name(W) standardize
use "所有变量.dta"
xtset id year 

*LR检验及三大模型
*sar
xsmle ICM GF lngdp FD FDI lnhc, model(sar) wmat(W) nolog fe
estimates store SAR
*sem
xsmle ICM GF lngdp FD FDI lnhc, model(sem) emat(W) nolog fe
estimates store SEM
*sdm
xsmle ICM GF lngdp FD FDI lnhc, model(sdm) wmat(W) nolog fe
estimates store SDM
*sdm不带控制变量
xsmle ICM GF, model(sdm) wmat(W) nolog fe
estimates store SDM2
outreg2 [SAR SEM SDM SDM2] using "GDP结果.doc", replace


*检验
lrtest SDM SAR
lrtest SDM SEM
outreg2 [SAR SEM SDM SDM2] using "三大空间模型结果.doc", replace

*wald检验
xsmle ICM GF lngdp FD FDI lnhc, model(sdm) wmat(W) nolog fe

test [Wx]GF = [Wx]lnhc = [Wx]lngdp= [Wx]FD= [Wx]FDI=0
testnl ([Wx]GF = -[Spatial]rho*[Main]GF)([Wx]lnhc= -[Spatial]rho*[Main]lnhc)([Wx]lngdp= -[Spatial]rho*[Main]lngdp)([Wx]FD= -[Spatial]rho*[Main]FD)([Wx]FDI= -[Spatial]rho*[Main]FDI)
*效应分解
xsmle ICM GF lngdp FD FDI lnhc, model(sdm) wmat(W) fe nolog effects
estimates store DE

outreg2 [DE] using "分解效应.doc", replace
