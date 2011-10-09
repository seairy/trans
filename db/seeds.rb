# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create({ :account => 'wanghao', :password => '123456', :password_confirmation => '123456', :name => '王皓', :role => User::ROLE_ADMIN, :prohibited => false })

Language.create([{ :name => '英语', :en_name => 'English' },
  { :name => '德语', :en_name => 'Deutsch' },
  { :name => '俄语', :en_name => 'Russian' },
  { :name => '韩国语', :en_name => 'Korean' },
  { :name => '日语', :en_name => 'Japanese' },
  { :name => '阿拉伯语', :en_name => 'Arabic' },
  { :name => '法语', :en_name => 'French' },
  { :name => '泰国语', :en_name => 'Thai' },
  { :name => '西班牙语', :en_name => 'Spanish' },
  { :name => '土耳其语', :en_name => 'Turkish' },
  { :name => '马来语', :en_name => 'Malay' },
  { :name => '意大利语', :en_name => 'Italian' },
  { :name => '印尼语', :en_name => 'Bahasa-Indonesia' },
  { :name => '波兰语', :en_name => 'Polish' },
  { :name => '荷兰语', :en_name => 'Dutch' },
  { :name => '匈牙利语', :en_name => 'Hungarian' },
  { :name => '葡萄牙语', :en_name => 'Portuguese' },
  { :name => '印地语', :en_name => 'Hindi' },
  { :name => '乌克兰语', :en_name => 'Ukrainian' },
  { :name => '希伯来语', :en_name => 'Hebrew' },
  { :name => '僧伽罗语', :en_name => 'Sinhala' },
  { :name => '菲律宾语', :en_name => 'Filipino' },
  { :name => '乌尔都语', :en_name => 'Urdu' },
  { :name => '波斯语', :en_name => 'Persian' },
  { :name => '斯瓦希里语', :en_name => 'Swahili' },
  { :name => '越南语', :en_name => 'Vietnamese' },
  { :name => '豪萨语', :en_name => 'Hao-Sayu' },
  { :name => '缅甸语', :en_name => 'Burmese' },
  { :name => '瑞典语', :en_name => 'Swedish' },
  { :name => '老挝语', :en_name => 'Lao' },
  { :name => '罗马尼亚语', :en_name => 'Romanian' },
  { :name => '保加利亚语', :en_name => 'Bulgarian' },
  { :name => '捷克语', :en_name => 'Czech' },
  { :name => '塞尔维亚语', :en_name => 'Serbian' },
  { :name => '尼泊尔语', :en_name => 'Nepali' },
  { :name => '斯洛伐克语', :en_name => 'Slovak' },
  { :name => '柬埔寨语', :en_name => 'Cambodian' },
  { :name => '丹麦语', :en_name => 'Danish' },
  { :name => '蒙古语', :en_name => 'Mongolian' },
  { :name => '阿尔巴尼亚语', :en_name => 'Albanian' },
  { :name => '芬兰语', :en_name => 'Finnish' },
  { :name => '克罗地亚语', :en_name => 'Croatian' },
  { :name => '冰岛语', :en_name => 'Icelandic' },
  { :name => '挪威语', :en_name => 'Norwegian' },
  { :name => '希腊语', :en_name => 'Greek' }])