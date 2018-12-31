class Page < ApplicationRecord
  belongs_to :site


  # after commit build/rebuild page 
  # need to render the page and apply template
  # if delete remove 
  # if update how to handle redirects
  #
end
