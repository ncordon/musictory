class PedidosController < ApplicationController
  def index
    @pedidos = Pedido.all

    if params[:search]
      @pedidos = Pedido.search(params[:search]).order("fechaRealizacion DESC")
    end
  end

  def new
    @pedido = Pedido.new
  end

  def create
    @pedido = Pedido.new(pedido_params)

    if @pedido.save
      redirect_to pedidos_path
    else
      render 'new'
    end
  end

  def destroy
    @pedido = Pedido.find(params[:id])

    if @pedido.destroy
      redirect_to pedidos_path
    end
  end

  def show
  end

  def cancel_order
    @pedido = Pedido.find(params[:id])
    @pedido.fechaCancelacion = Time.now

    if @pedido.save
      redirect_to pedidos_path
    else
      render 'index'
    end
  end


  def received
    @pedidos = Pedido.where.not(fechaEntrada: nil)

    if params[:search]
      @pedidos = Pedido.where.not(fechaEntrada: nil).search(params[:search]).order("fechaRealizacion DESC")
    end
  end

  def non_received
    @pedidos = Pedido.where(fechaEntrada: nil).where(fechaCancelacion: nil)

    if params[:search]
      @pedidos = Pedido.where(fechaEntrada: nil).where.not(fechaCancelacion: nil).search(params[:search]).order("fechaRealizacion DESC")
    end
  end


  def cancelled
    @pedidos = Pedido.where.not(fechaCancelacion: nil)

    if params[:search]
      @pedidos = Pedido.where.not(fechaCancelacion: nil).search(params[:search]).order("fechaRealizacion DESC")
    end
  end


  def receive_order
    @pedido = Pedido.find(params[:id])
    @pedido.fechaEntrada = Time.now

    if @pedido.save
      if @pedido.cd?
        @cd = Cd.where(catalogo_id: @pedido.catalogo_id).first
        @cd.cantidad = @cd.cantidad + @pedido.cantidad
        @cd.save
      elsif @pedido.vinilo?
        @vinilo = Vinilo.where(catalogo_id: @pedido.catalogo_id).first
        @vinilo.cantidad = @vinilo.cantidad + @pedido.cantidad
        @vinilo.save
      end

      redirect_to pedidos_path
    else
      render 'index'
    end
  end

  private
    def pedido_params
      params[:pedido][:fechaRealizacion] = Time.now
      params.require(:pedido).permit(:titulo,:grupo,:fechaRealizacion,:formato,:cantidad)
    end
end
