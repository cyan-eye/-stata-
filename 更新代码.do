xtset id year

pwcorr GF GTI HTE lngdp FD FDI lnhc, sig star(0.05)
reg ICM GF GTI HTE lngdp FD FDI lnhc
vif

preserve
keep if 城市群 == "京津冀"
* 设置面板结构
xtset id year

* 模型1：OLS 不含控制变量
reg ICM GF
est store model1
* 模型2：OLS 含控制变量
reg ICM GF lngdp FD FDI lnhc
est store model2

* 模型3：固定效应，不含控制变量
xtreg ICM GF, fe
est store model3
* 模型4：固定效应，含控制变量
xtreg ICM GF lngdp FD FDI lnhc, fe
est store model4

outreg2 [model1 model2 model3 model4] using "四项基础回归.doc", replace
* 如果要加年份固定效应，就在 xtreg 后加 i.year，比如：
* xtreg ICM GF ED HC GOV RD FD FDI i.year, fe

drop if year == 2010
drop if year == 2011
drop if year == 2012
* Step 1: 总效应模型
xtreg ICM GF lngdp FD FDI lnhc, fe
* Step 2: 自变量对中介变量
xtreg HTE GF lngdp FD FDI lnhc, fe
* Step 3: 自变量 + 中介变量作用于因变量
xtreg ICM GF HTE lngdp FD FDI lnhc, fe


xtreg ICM GF lngdp FD FDI lnhc, fe
* Step 2: 自变量对中介变量
xtreg GTI GF lngdp FD FDI lnhc, fe
* Step 3: 自变量 + 中介变量作用于因变量
xtreg ICM GF GTI lngdp FD FDI lnhc, fe


* Bootstrap 测试中介效应（推荐）
bootstrap, reps(500): xtreg ICM GF GTI HC GOV RD FD FDI, fe


reg ICM GF HC GOV RD FD FDI
reg GTI GF HC GOV RD FD FDI
reg ICM GF GTI HC GOV RD FD FDI


reg ICM xy HC GOV RD FD FDI
est store model1
xtreg ICM xy HC GOV RD FD FDI, fe
est store model2

outreg2 [model1 model2] using "F:\框艳论文修改\交互项.doc", word replace


restore
