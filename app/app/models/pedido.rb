class Pedido < ApplicationRecord
  belongs_to :catalogo
  enum formato: [:cd, :vinilo]
  #belongs_to :proveedor

  #validates :adeudo, presence: true, numericality: {greater_than: 0}

  validates :cantidad, presence: {message: "%{value} no puede ser vacío"},
    numericality: {
      greater_than: 0,
      only_integer: true,
      message: "Se esperaba un número mayor que 0"
    }

  validates :formato,
    inclusion: {
      in: formatos.keys,
      message: "no es un formato válido. Se esperaba CD o Vinilo"
    }

  validates :fechaRealizacion, presence: true
  validates_date_of :fechaRealizacion, before_or_equal_to:  Proc.new { Time.now }

  validates_date_of :fechaEntrada,
    after: :fechaRealizacion,
    unless: Proc.new { |a| a.fechaEntrada.nil?},
    message: "debe ser posterior a la de realización del pedido"

  validates_date_of :fechaCancelacion,
    after: :fechaRealizacion, before: :fechaEntrada,
    unless: Proc.new { |a| a.fechaCancelacion.nil? },
    message: "debe ser posterior a la de realización del pedido, y anterior a la fecha de entrada"

  validates_date_of :fechaFinalizacion,
    after: :fechaEntrada,
    unless: Proc.new { |a| a.fechaFinalizacion.nil? },
    message: "debe ser posterior a la de entrada"

  validates_date_of :fechaDefecto,
    after: :fechaEntrada,
    unless: Proc.new { |a| a.fechaDefecto.nil? },
    message: "debe ser posterior a la de entrada"


  def self.search(search)
    joins(:catalogo).where("titulo LIKE ? OR grupo LIKE ? OR fechaRealizacion LIKE ?",
      "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
