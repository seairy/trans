# -*- encoding : utf-8 -*-
class Operation < ActiveRecord::Base
  ACTION_GENERATE, ACTION_ASSIGN, ACTION_ARCHIVE_AND_SENT, ACTION_UPLOAD_AND_TRANSLATE, ACTION_APPROVE, ACTION_ARCHIVE_AND_FINISH = 1, 2, 3, 4, 5, 6
  belongs_to :translation
  belongs_to :user
end