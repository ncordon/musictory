class Vinilo < ApplicationRecord
  belongs_to :catalogo

  validates :cantidad,
    presence: {message: "%{value} no puede ser vacío"},
    numericality: {
      greater_than_or_equal: 0,
      only_integer: true
    }

  validates :precio,
    presence: {message: "%{value} no puede ser vacío"},
    numericality: {
      greater_than: 0,
      message: "%{value} debe ser mayor que 0"
    }, if: :vinilos?

  def vinilos?
    cantidad > 0
  end
end
