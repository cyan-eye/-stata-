*统计性检验、多重共线性检验
xtset id year

pwcorr GF GTI HTE lngdp FD FDI lnhc, sig star(0.05)
reg ICM GF GTI HTE lngdp FD FDI lnhc
vif

*基础回归模型
reg ICM GF
reg ICM GF lngdp FD FDI lnhc


xtreg ICM GF, fe
xtreg ICM GF lngdp FD FDI lnhc, fe

*机制检验
xtreg ICM GF lngdp FD FDI lnhc, fe
xtreg GTI GF lngdp FD FDI lnhc, fe
xtreg ICM GF GTI lngdp FD FDI lnhc, fe

reg ICM GF lngdp FD FDI lnhc
reg GTI GF lngdp FD FDI lnhc
reg ICM GF GTI lngdp FD FDI lnhc

*莫兰指数的报告
preserve
keep if year == 2023

spatwmat using W50.dta, name(W) standardize
spatgsa GF, weights(W) moran geary 

spatlsa GF, weights(W) moran graph(moran) symbol(n)
restore

*空间回归
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

*wald检验
xsmle ICM GF lngdp FD FDI lnhc, model(sdm) wmat(W) nolog fe
test [Wx]GF = [Wx]lnhc = [Wx]lngdp= [Wx]FD= [Wx]FDI=0
testnl ([Wx]GF = -[Spatial]rho*[Main]GF)([Wx]lnhc= -[Spatial]rho*[Main]lnhc)([Wx]lngdp= -[Spatial]rho*[Main]lngdp)([Wx]FD= -[Spatial]rho*[Main]FD)([Wx]FDI= -[Spatial]rho*[Main]FDI)

*效应分解
xsmle ICM GF lngdp FD FDI lnhc, model(sdm) wmat(W) fe nolog effects
estimates store DE

*市场化分析
reg ICM xy
reg ICM xy lngdp FD FDI lnhc
xtreg ICM xy
xtreg ICM xy lngdp FD FDI lnhc, fe

*稳健性检验
winsor2 ICM GF GTI lngdp FD FDI lnhc, cuts(1 99)
xtreg ICM GF lngdp FD FDI lnhc, fe
* Step 2: 自变量对中介变量
xtreg GTI GF lngdp FD FDI lnhc, fe
* Step 3: 自变量 + 中介变量作用于因变量
xtreg ICM GF GTI lngdp FD FDI lnhc, fe

*DID
gen did = post * treat
reg ICM did GF HC GOV RD FD FDI, robust
outreg2 using result.doc, replace word

*内生性检验
ivregress 2sls ICM lngdp FD FDI lnhc (GF = L.GF)
reg ICM GF lngdp FD FDI lnhc
est store ols
ivregress 2sls ICM lngdp FD FDI lnhc (GF = L.GF)
est store iv
hausman iv ols, constant sigmamore

estat firststage,forcenonrobust all



