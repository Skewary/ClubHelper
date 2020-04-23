namespace :init do
  task :college, [] => :environment do |t, args|
    ApplicationRecord.transaction do
      College.destroy_all
      College.create! name: "士谔书院", code: 73
      College.create! name: "冯如书院", code: 74
      College.create! name: "士嘉书院", code: 75
      College.create! name: "守锷书院", code: 76
      College.create! name: "致真书院", code: 77
      College.create! name: "知行书院", code: 79
      College.create! name: "材料科学与工程学院", code: 1
      College.create! name: "电子信息工程学院", code: 2
      College.create! name: "自动化科学与电气工程学院", code: 3
      College.create! name: "能源与动力工程学院", code: 4
      College.create! name: "航空科学与工程学院", code: 5
      College.create! name: "计算机学院", code: 6
      College.create! name: "机械工程及自动化学院", code: 7
      College.create! name: "经济管理学院", code: 8
      College.create! name: "数学与系统科学学院", code: 9
      College.create! name: "生物与医学工程学院", code: 10
      College.create! name: "人文社会科学学院（公共管理学院）", code: 11
      College.create! name: "外国语学院", code: 12
      College.create! name: "交通科学与工程学院", code: 13
      College.create! name: "可靠性与系统工程学院", code: 14
      College.create! name: "宇航学院", code: 15
      College.create! name: "飞行学院", code: 16
      College.create! name: "仪器科学与光电工程学院", code: 17
      College.create! name: "北京学院", code: 18
      College.create! name: "物理科学与核能工程学院", code: 19
      College.create! name: "法学院", code: 20
      College.create! name: "软件学院", code: 21
      College.create! name: "远程教育学院", code: 22
      College.create! name: "高等工程学院", code: 23
      College.create! name: "中法工程师学院", code: 24
      College.create! name: "国际学院", code: 25
      College.create! name: "新媒体艺术与设计学院", code: 26
      College.create! name: "化学与环境学院", code: 27
      College.create! name: "思想政治理论学院", code: 28
      College.create! name: "人文与社会科学高等研究院", code: 29
      College.create! name: "空间与环境学院", code: 30
    end
    puts "College initialize complete!"
  end

  task :political_status, [] => :environment do |t, args|
    ApplicationRecord.transaction do
      PoliticalStatus.all.destroy_all
      PoliticalStatus.create! name: "群众", code: 0
      PoliticalStatus.create! name: "共青团员", code: 1
      PoliticalStatus.create! name: "中共预备党员", code: 2
      PoliticalStatus.create! name: "中共党员", code: 3
      PoliticalStatus.create! name: "民革党员", code: 4
      PoliticalStatus.create! name: "民盟盟员", code: 5
      PoliticalStatus.create! name: "民建会员", code: 6
      PoliticalStatus.create! name: "民进会员", code: 7
      PoliticalStatus.create! name: "农工党党员", code: 8
      PoliticalStatus.create! name: "致公党党员", code: 9
      PoliticalStatus.create! name: "九三学社社员", code: 10
      PoliticalStatus.create! name: "台盟盟员", code: 11
      PoliticalStatus.create! name: "无党派人士", code: 12
    end
    puts "Political status initialize complete!"
  end
end