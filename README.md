# vir_one
 基于元胞自动机方法的新冠病毒传播研究与疫情防控思路（使用MATLAB完成）:
      my_virus.m文件为无防疫措施仿真
      my_virus_geli.m文件为隔离措施仿真
      my_virus_kouzhao.m文件为佩戴口罩仿真
      
     1.仿真环境：
      1）划定区域：带有人行横道的十字路口。区域总面积为100*100单位面积，马路宽20单位，每一条人行横道均宽10单位。
      2）人群分布：初始情况下，被分为四块的人群均在各自区域内服从正态分布，马路上禁止行人通行，只能通过人行横道到达另一区域。
![add image](https://github.com/JunkWarrior001/vir_one/blob/master/init_people.png)
     
     2.病毒传播规则：
      1）根据人受病毒的影响不同，将人分为健康人，病毒携带者（无症状），病毒感染者（有症状）三类。在初始情况下，随机生成一病毒感染者，其余人为健康人。
      2）根据新冠病毒的传播特点，并做适当简化，我们假设病毒可由携带者和感染者向健康人进行传染，且传播概率随人体间距离变化而变化，如下图：            
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_spread.png)

      假设除周边8个单位的范围之外，病毒不传染。
      3)病毒对人体的影响程度受时间的影响：设当人成为携带者超过20单位时间后，根据个体的差异性对病毒做出不同的反应：1/3概率继续作为携带者存在，
      1/6概率产生免疫能力康复并失去传染能力（同时也不会再次被感染），1/2概率进一步恶化成为感染者
     
     3.行人的运动规则（元胞自动机思想）：
      1）位置初始化（已实现，正态分布）
      2）半随机化运动策略：考虑真实情况，十字路口附近的行人虽然具体行动随机，但有一个概略的目标，即：至少有一次穿过人行横道到达对面的行动。基于此，我们在进行元胞位置的转移时，分三种情况执行不同的策略：a.当前元胞位置不在人行横道上，且从未横穿过人行横道，执行策略：增大该元胞向人行横道方向移动的概率。 b.当前元胞处于人行横道上，执行策略：直线前进随机大小的长度，直到到达另一侧街道。 c.当前元胞不在人行横道上，且已经至少穿过了一次马路，执行策略：使该元胞运动全随机。
   上述中的a策略保证了十字路口这一环境的真实性，即人们至少会有一次穿过马路，保证了行人在区域间的不断流动。b,c策略则在兼顾真实性（过马路时快速，直线通过）的同时，减小了由a策略造成的人流过于集中于人行横道的这一不良影响。
   基于以上环境与策略，运行一次my_virus.m程序得到病毒传播过程如下（截取部分过程，绿色点：健康人，蓝色点：携带者，红色点：感染者）：

![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_spread1.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_spread2.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_spread3.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_spread4.png)

      接下来，我们进行数据分析，我们记录下每个单位时间里，感染者，携带者，健康者的人数变化，任取两次传播过程的数据，绘制成曲线图，如下所示：
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data1.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data2.png)

      从曲线可以看出，三类人群的变化趋势基本符合我们的假设情况以及预期。
      1）前期，携带者随着人数的增加，增长速度也逐渐加快，在20单位时间以后，增长放缓，并逐渐到达峰值（20单位时间以后携带者部分转为健康者或感染者），之后逐渐减少。具体的峰值时刻与人群的初始分布和随机运动过程有关。
      2）由于携带者需要时间转变为感染者，感染者前期数量不变（为1），且在20单位时间后开始增长，增长幅度与携带者基数成正相关，人数随时间推移不断增加。
      3）在20单位时间以前，健康者人数满足：健康者=200-携带者。20单位时间后，健康者人数降低速度减慢并最终到达一最小值，之后小幅回升。可以预见到，随着时间的进一步推移，健康者会以较小的速度继续增加。这部分人群由携带者康复而来，本身对病毒有抵抗力，不会再次感染。这也就是所谓的“自然免疫”，“群体免疫”的一种简化表达。
      
      我们对上述结论2进行进一步研究，针对两次传播过程，我们对随时间变化的感染者人数分别做中心差分，近似得到感染者人数对时间的导数曲线如下所示：
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_chafen1.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_chafen2.png)

      可以看出，感染者人数曲线的导数在形状上与其对应的携带者变化曲线相当，但时间上有延时，这部分延时即是由病毒在携带者身上潜伏的20个单位时间造成的。以上分析表明，在不精确的情形下，可以将无症状携带者数据作为依据，来估计有症状感染者的增长速度快慢。
     
      接下来，我们从隔离，佩戴口罩，保持社交距离三个方面出发，研究不同防疫措施对病毒扩散的抑制作用。
      首先是隔离法。实际的隔离法过程十分复杂。首先，医疗单位需要准确掌握片区内每个人的身体状况，只有得到患者症状的上报，相关机构才能采取措施。也就是说，隔离的作用对象只能是已经表现出症状的感染者（不包括无症状携带者）。这一般情况下会存在一定的延迟。这里，我们首先假定在理想情况下进行隔离，即有症状患者一出现，在下一个时刻立马被隔离（即脱离当前环境），同时，为了保证人群的密度，在有人被隔离后，我们立即在合法区域内随机生成一个新的健康者个体。我们多次运行程序，得到如下三种最终情况（50单位时间后）：
 ![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data_geli.png)
 ![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data_geli2.png)
 ![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data_geli3.png)
 
      上图中，图一是一种特殊情况，如果一片区域的第一个感染者能够得到迅速的隔离，则这片区域完全不会出现感染者，二，三图则是在初始感染者已经在第一个单位时间传染他人后，病毒扩散的情况，可以看到，病毒扩散的情况依然得到了极大的遏制，只有当前时刻新出现的感染者能够出现在区域中，而其他人员都得到了很好的隔离。
 ![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_geli_anly.png)
 
      我们选取了最终时刻的健康者人数，携带者人数，感染者人数，携带者峰值到来的时刻，携带者峰值大小这五个指标来观察采取防疫指标后病毒扩散的表现情况。我们从隔离前后的运行结果中各取若干组样本求取平均值，结果如上图所示。可以看到，平均健康者人数，隔离后远大于隔离前，平均感染者人数则远远小于隔离前。另外，从病毒携带者的峰值时间来看，隔离后也要迟与隔离前。综合这些表现说明，隔离这一措施一方面能够极大地减少一定区域内的感染者人数，另一方面，也能使病毒的扩散受到延迟。
      
      接下来是佩戴口罩法。显然，佩戴口罩只能在病毒感染人体之前起阻隔作用，我们将口罩的作用定量地等效为病毒感染的概率降低为一半，其他条件与无措施时一致，得到如下结果图：
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data_kouzhao.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data_kouzhao2.png)
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_data_kouzhao3.png)

      对比使用隔离方法的效果图，直观看来，口罩法在最终结果上改良似乎并不大，我们接下来进行各项指标的比对，如下表：
![Image text](https://github.com/JunkWarrior001/vir_one/blob/master/virus_kouzhao_anly.png)
      
      可以看出，人们佩戴口罩后，相比不采取措施，最终的健康人数基本相当，但受病毒影响的人中，佩戴口罩后，携带者增多而感染者减少，再仔细观察，佩戴口罩后，携带者峰值到来的时刻最迟。由此可以得知，佩戴口罩从最终结果来看，无法使健康的人数增多，但能够显著地延缓病毒的传播，给国家采取进一步措施争取时间。
      
      最后讲讲保持社交距离这一措施。保持社交距离在本质上是减小了同样地域内的人口密度，同时对于病毒传播的概率也需要进行更大范围内的，更精细的设计，另外，对于执行随机化运动策略的我本次建立的病毒传播模型而言难以实现，因此只做简单分析。从根本上来讲，保持社交距离与佩戴口罩较为类似，核心思想都是阻塞病毒在人与人之间的传播，但并没有将传染来源的感染者从环境中移出。因而只能在一定程度上延缓病毒在环境中的蔓延。
      
      整体防疫建议：
        1.新冠病毒的传播迅速而难以抵御，由于无症状携带者的存在，对该病毒的防治有了更多的不确定因素。相关部门需要引起高度重视，如果一个地区已经出现了有症状感染者，说明疫情已经相当严重，需要采取一切必要的措施进行防治。
      	2.防疫的思路可以从阻塞病毒的传播通道以及消除环境中的传染源两方面着手，前者可以通过规定必须佩戴口罩，保持社交距离来实现；后者可以通过隔离感染者或是治愈患者实现。
	3.隔离措施的重点在于随时掌握区域内每个个体的身体健康情况，了解的越详细及时，隔离的效果就越好（上文中，我们用理想情况进行了仿真。我们可以很容易的想到，如果感染者出现后，获得该患者信息并进行隔离的反应时间无限延长，则病毒扩散情况则无限接近于无防疫措施的情况）。
	4.保持社交距离和要求佩戴口罩能起到慢化病毒蔓延的作用，但这并不是从根本上解决问题的方法，政府需要利用由此得来的时间对疫情形势进行深度研究，掌握新冠病毒更多的信息。同时，此二种措施对社会的正常经济秩序与人际交往都会产生一定程度的影响，政府在实际执行时需要拿捏好尺度，避免造成过大的损失。
 
      
	
