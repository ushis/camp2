module ActsAsList
  extend ActiveSupport::Concern

  private

  def update_positions_of(assoc, ids)
    transaction do
      send(assoc).each do |item|
        item.update_attribute(:position, ids.index(item.id))
      end
    end
  end

  public

  module ClassMethods
    def acts_as_list_of(assoc)
      define_method("#{assoc.to_s.singularize}_positions=") do |ids|
        update_positions_of(assoc, Array.wrap(ids))
      end
    end
  end
end
