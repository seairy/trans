# -*- encoding : utf-8 -*-
module ApplicationHelper
  
  def odevity_tag index
    (index + 1) % 2 == 0 ? 'even' : 'odd'
  end

  def empty_record_tag
    "<tr><td colspan=\"10\" class=\"empty\">没有任何记录！</td></tr>"
  end
  
  def crud_for_list_tag record, options = {}
    crud_actions = []
    crud_actions << "#{image_tag 'ico_show.png', :alt => '查看'} #{link_to '查看', (options[:show_path] || record)}" unless options[:discard_show]
    crud_actions << "#{image_tag 'ico_edit.png', :alt => '编辑'} #{link_to '编辑', (options[:edit_path] || url_for(record) + '/edit')}" unless options[:discard_edit]
    crud_actions << "#{image_tag 'ico_destroy.png', :alt => '删除'} #{link_to '删除', (options[:destroy_path] || record), :confirm => '确定删除该记录？', :method => :delete}" if !options[:discard_destroy]
    crud_actions.join ' | '
  end

  def crud_for_show_tag record, options = {}
    crud_actions = []
    crud_actions << "#{link_to '添加', url_for(record.class.new) + '/new', :class => 'button'}" unless options[:discard_new]
    crud_actions << "#{link_to '编辑', (options[:edit_path] || url_for(record) + '/edit'), :class => 'button'}" unless options[:discard_edit]
    crud_actions << "#{link_to '删除', (options[:destroy_path] || record), :class => 'button', :confirm => '确定删除该记录？', :method => :delete}" if !options[:discard_destroy]
    crud_actions << "#{link_to '返回', (options[:return_path] || record.class.new), :class => 'button'}" unless options[:discard_return]
    crud_actions.join ' '
  end
  
  def user_id_in_session
    session[:user_id]
  end
  
  def user_name_in_session
    session[:user_name]
  end
  
  def user_role_in_session
    session[:user_role]
  end
  
  def signined?
    !user_id_in_session.blank?
  end
  
  def flash_tag
    if flash[:alert]
      content_tag 'p', h(flash[:alert]), :class => 'notice alert'
    elsif flash[:notice]
      content_tag 'p', h(flash[:notice]), :class => 'notice'
    end
  end
  
  def permissable_for roles = []
    raise ArgumentError, 'Missing block' unless block_given?
    raw yield if roles.include?(user_role_in_session) or user_role_in_session == User::ROLE_ADMIN
  end
  
  def human_boolean_for boolean
    boolean ? '是' : '否'
  end
  
  def human_date_for date
    date.strftime '%Y-%m-%d' unless date.blank?
  end
  
  def human_datetime_for datetime
    datetime.strftime '%Y-%m-%d %H:%M' unless datetime.blank?
  end
  
  def human_text_for text
    RedCloth.new(text).to_html unless text.blank?
  end
  
  def human_priority_for priority
    case priority
    when 1 then '一般'
    when 2 then '紧急'
    when 3 then '非常紧急'
    end
  end
  
  def human_word_count_for word_count
    word_count || '未统计'
  end
  
  def human_user_role_for user_role
    case user_role
    when User::ROLE_ADMIN then '管理员'
    when User::ROLE_CIO_MANAGER then '网络公司经理'
    when User::ROLE_EDITOR then '网络公司员工'
    when User::ROLE_HF_MANAGER then '汉风公司经理'
    when User::ROLE_ASSIGNEE then '汉风公司员工'
    end
  end
  
  def human_employee_role_for employee_role
    case employee_role
    when Employee::ROLE_LINGUISTER then '译员'
    when Employee::ROLE_EMBELLISHER then '润色'
    when Employee::ROLE_READER then '审稿'
    when Employee::ROLE_EDITOR then '编辑'
    end
  end
  
  def human_translation_state_for translation_state
    case translation_state
    when Translation::STATE_GENERATED then '等待指派'
    when Translation::STATE_ASSIGNED then '已指派，等待翻译'
    when Translation::STATE_SENT then '已发出，等待回稿'
    when Translation::STATE_TRANSLATED then '已翻译，等待审核'
    when Translation::STATE_APPROVED then '已审核'
    when Translation::STATE_FINISHED then '已完成'
    end
  end
  
  def human_operation_action_for operation_action
    case operation_action
    when Operation::ACTION_GENERATE then '生成'
    when Operation::ACTION_ASSIGN then '指派'
    when Operation::ACTION_ARCHIVE_AND_SENT then '归档及送翻'
    when Operation::ACTION_UPLOAD_AND_TRANSLATE then '回稿及上传'
    when Operation::ACTION_APPROVE then '审核'
    when Operation::ACTION_ARCHIVE_AND_FINISH then '归档及定稿'
    end
  end
  
  def user_role_options_for_select options = {}
    user_role_options = {}
    user_role_options.merge!({ '管理员' => User::ROLE_ADMIN }) if [User::ROLE_ADMIN].include? user_role_in_session
    user_role_options.merge!({ '网络公司经理' => User::ROLE_CIO_MANAGER }) if [User::ROLE_ADMIN].include? user_role_in_session
    user_role_options.merge!({ '网络公司员工' => User::ROLE_EDITOR }) if [User::ROLE_ADMIN, User::ROLE_CIO_MANAGER].include? user_role_in_session
    user_role_options.merge!({ '汉风公司经理' => User::ROLE_HF_MANAGER }) if [User::ROLE_ADMIN].include? user_role_in_session
    user_role_options.merge!({ '汉风公司员工' => User::ROLE_ASSIGNEE }) if [User::ROLE_ADMIN, User::ROLE_HF_MANAGER].include? user_role_in_session
    options_for_select user_role_options, options
  end
  
  def employee_role_options_for_select options = {}
    employee_role_options = {}
    employee_role_options.merge!({ '译员' => Employee::ROLE_LINGUISTER })
    employee_role_options.merge!({ '润色' => Employee::ROLE_EMBELLISHER })
    employee_role_options.merge!({ '审稿' => Employee::ROLE_READER })
    employee_role_options.merge!({ '编辑' => Employee::ROLE_EDITOR })
    options_for_select employee_role_options, options
  end
  
  def translation_state_options_for_select options = {}
    translation_state_options = {}
    translation_state_options.merge!({ '等待指派' => Translation::STATE_GENERATED })
    translation_state_options.merge!({ '已指派，等待翻译' => Translation::STATE_ASSIGNED })
    translation_state_options.merge!({ '已发出，等待回稿' => Translation::STATE_SENT })
    translation_state_options.merge!({ '已翻译，等待审核' => Translation::STATE_TRANSLATED })
    translation_state_options.merge!({ '已审核' => Translation::STATE_APPROVED })
    translation_state_options.merge!({ '已完成' => Translation::STATE_FINISHED })
    options_for_select translation_state_options, options
  end
  
  def all_languages
    Language.all
  end
  
  def all_assignees
    User.where(role:User::ROLE_ASSIGNEE)
  end
end

