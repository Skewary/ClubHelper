namespace :v0 do
  task show_name: :environment do
    puts User.column_names
  end
end

namespace :v1 do
  task import: :environment do
    tables = [ClubCategory, Club, Activity, Article,
              ClubToActivity,College, PoliticalStatus, User, UserFollowClub,
              UserFollowActivity, UserJoinClub]
    sheet_table = ["ClubCategoty", "Club", "Activity", "Article",
                   "ClubToActivity","College", "PoliticalStatus", "User", "UserFollowClub",
                   "UserFollowActivity", "UserJoinClub"]
    UserJoinActivity.delete_all
    tables.reverse.each do |tb|
      tb.delete_all
      #puts tb.to_s
    end

    require 'roo'
    file = "#{Rails.root}/tmp/indata.xlsx" # 将文本路径赋给对象
    if File.exists?(file)
      # 打开文本赋值给xlsx对象，将文本第一列赋值给对象sheet
      xlsx = Roo::Spreadsheet.open(file)

      len = 11
      index = (0...len)
      index.each do |i|
        puts sheet_table[i]
        sheet = xlsx.sheet(i)

        # 这里将读取出来的数据更新到数据表中
        puts sheet.class
        puts sheet.first.class
        puts sheet.first.length


        #puts sheet[0]
        row_cnt = 0
        sheet.each do |row|
          if row != sheet.first
            #offer = ClubCategory.find_by(id: row[0])
            new_row = {}
            cnt = 0
            sheet.first.each do |name|
              puts name, row[cnt]
              new_row[name.to_sym] = row[cnt]
              cnt += 1
            end
            puts new_row
            tables[i].create!(new_row)
            # offer.update_columns(new_row)
          end
        end
      end
    end
  end
end
