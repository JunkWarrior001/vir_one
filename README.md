# vir_one
 基于元胞自动机的新冠病毒传播模型与疫情防控思路（使用MATLAB完成）:
	
       1.仿真环境：
	1）划定区域：带有人行横道的十字路口。区域总面积为100*100单位面积，马路宽20单位，每一条人行横道均宽10单位。
	2）人群分布：初始情况下，被分为四块的人群均在各自区域内服从正态分布，马路上禁止行人通行，只能通过人行横道到达另一区域。
        ![Image discription](https://github.com/JunkWarrior001/vir_one/blob/master/init_people.png)
       2.病毒传播规则：
	1）根据人受病毒的影响不同，将人分为健康人，病毒携带者，病毒感染者三类。在初始情况下，随机生成一病毒感染者，其余人为健康人。
	2）根据新冠病毒的传播特点，并做适当简化，我们假设病毒可由携带者和感染者向健康人进行传染，且传播概率随人体间	 距离变化而变化，如下图：
	![Image discription](https://github.com/JunkWarrior001/vir_one/blob/master/virus_spread.png)
