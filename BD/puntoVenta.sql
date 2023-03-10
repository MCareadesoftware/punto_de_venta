USE [ImportacionesNet]
GO
/****** Object:  User [sp_]    Script Date: 08/10/2020 13:50:17 ******/
CREATE USER [sp_] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[sp_]
GO
/****** Object:  Schema [sp_]    Script Date: 08/10/2020 13:50:18 ******/
CREATE SCHEMA [sp_]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 08/10/2020 13:50:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[IdCliente] [nvarchar](5) NOT NULL,
	[NombreCompañía] [nvarchar](40) NOT NULL,
	[NombreContacto] [nvarchar](30) NULL,
	[CargoContacto] [nvarchar](30) NULL,
	[Dirección] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Región] [nvarchar](15) NULL,
	[CódPostal] [nvarchar](10) NULL,
	[País] [nvarchar](15) NULL,
	[Teléfono] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleados]    Script Date: 08/10/2020 13:50:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleados](
	[IdEmpleado] [int] NOT NULL,
	[Apellidos] [nvarchar](20) NOT NULL,
	[Nombre] [nvarchar](10) NOT NULL,
	[Cargo] [nvarchar](30) NULL,
	[Tratamiento] [nvarchar](25) NULL,
	[FechaNacimiento] [smalldatetime] NULL,
	[FechaContratación] [smalldatetime] NULL,
	[Dirección] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Región] [nvarchar](15) NULL,
	[CódPostal] [nvarchar](10) NULL,
	[País] [nvarchar](15) NULL,
	[TelDomicilio] [nvarchar](24) NULL,
	[Extensión] [nvarchar](4) NULL,
	[Foto] [image] NULL,
	[Notas] [ntext] NULL,
	[Jefe] [int] NULL,
 CONSTRAINT [PK_Empleados] PRIMARY KEY CLUSTERED 
(
	[IdEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Boleta]    Script Date: 08/10/2020 13:50:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Boleta](
	[IdBoleta] [int] NOT NULL,
	[IdCliente] [nvarchar](5) NOT NULL,
	[IdEmpleado] [int] NULL,
	[FechaPedido] [smalldatetime] NULL,
	[Suspendido] [bit] NULL,
 CONSTRAINT [PK_Boleta] PRIMARY KEY CLUSTERED 
(
	[IdBoleta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_BoletaCabecera]    Script Date: 08/10/2020 13:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[View_BoletaCabecera]
as
SELECT     Boleta.IdBoleta, Clientes.NombreCompañía, Empleados.Nombre + ' ' + Empleados.Apellidos AS Nombre, Boleta.FechaPedido, Boleta.Suspendido
FROM         Boleta INNER JOIN
                      Clientes ON Boleta.IdCliente = Clientes.IdCliente INNER JOIN
                      Empleados ON Boleta.IdEmpleado = Empleados.IdEmpleado
GO
/****** Object:  Table [dbo].[DetallesBoleta]    Script Date: 08/10/2020 13:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesBoleta](
	[IdBoleta] [int] NULL,
	[IdProducto] [int] NOT NULL,
	[PrecioUnidad] [money] NOT NULL,
	[Cantidad] [smallint] NOT NULL,
	[Descuento] [real] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 08/10/2020 13:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[IdProducto] [int] NOT NULL,
	[NombreProducto] [nvarchar](40) NOT NULL,
	[IdProveedor] [int] NULL,
	[IdCategoría] [int] NULL,
	[CantidadPorUnidad] [nvarchar](20) NULL,
	[PrecioUnidad] [money] NULL,
	[UnidadesEnExistencia] [smallint] NULL,
	[UnidadesEnPedido] [smallint] NULL,
	[Suspendido] [bit] NOT NULL,
	[imagen] [nvarchar](50) NULL,
	[image] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_BoletaCuerpo]    Script Date: 08/10/2020 13:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[view_BoletaCuerpo]
as
SELECT     DetallesBoleta.IdBoleta, Productos.NombreProducto, DetallesBoleta.PrecioUnidad, DetallesBoleta.Cantidad,DetallesBoleta.PrecioUnidad * DetallesBoleta.Cantidad as [SubTotal]
FROM         DetallesBoleta INNER JOIN
                      Productos ON DetallesBoleta.IdProducto = Productos.IdProducto
GO
/****** Object:  Table [dbo].[Factura]    Script Date: 08/10/2020 13:50:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Factura](
	[IdFactura] [int] NOT NULL,
	[IdCliente] [nvarchar](5) NOT NULL,
	[IdEmpleado] [int] NULL,
	[FechaPedido] [smalldatetime] NULL,
	[Suspendido] [bit] NULL,
 CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED 
(
	[IdFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_FacturaCabecera]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[View_FacturaCabecera]
as
SELECT     Factura.IdFactura, Clientes.NombreCompañía, Empleados.Nombre + ' ' + Empleados.Apellidos AS Nombre, Factura.FechaPedido, Factura.Suspendido
FROM         Factura INNER JOIN
                      Clientes ON Factura.IdCliente = Clientes.IdCliente INNER JOIN
                      Empleados ON Factura.IdEmpleado = Empleados.IdEmpleado
GO
/****** Object:  Table [dbo].[DetallesFactura]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetallesFactura](
	[IdFactura] [int] NULL,
	[IdProducto] [int] NOT NULL,
	[PrecioUnidad] [money] NOT NULL,
	[Cantidad] [smallint] NOT NULL,
	[Descuento] [real] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_FacturaCuerpo]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[view_FacturaCuerpo]
as
SELECT     DetallesFactura.IdFactura, Productos.NombreProducto, DetallesFactura.PrecioUnidad, DetallesFactura.Cantidad,DetallesFactura.PrecioUnidad * DetallesFactura.Cantidad as [SubTotal]
FROM         DetallesFactura INNER JOIN
                      Productos ON DetallesFactura.IdProducto = Productos.IdProducto
GO
/****** Object:  View [dbo].[View_BoletaImpresion]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_BoletaImpresion]
AS
SELECT     dbo.View_BoletaCabecera.IdBoleta, dbo.View_BoletaCabecera.NombreCompañía, dbo.View_BoletaCabecera.Nombre, 
                      dbo.View_BoletaCabecera.FechaPedido, dbo.View_BoletaCabecera.Suspendido, dbo.view_BoletaCuerpo.NombreProducto, 
                      dbo.view_BoletaCuerpo.PrecioUnidad, dbo.view_BoletaCuerpo.Cantidad, dbo.view_BoletaCuerpo.SubTotal
FROM         dbo.View_BoletaCabecera INNER JOIN
                      dbo.view_BoletaCuerpo ON dbo.View_BoletaCabecera.IdBoleta = dbo.view_BoletaCuerpo.IdBoleta
GO
/****** Object:  View [dbo].[View_FacturaImpresion]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_FacturaImpresion]
AS
SELECT     dbo.View_FacturaCabecera.IdFactura, dbo.View_FacturaCabecera.NombreCompañía, dbo.View_FacturaCabecera.Nombre, 
                      dbo.View_FacturaCabecera.FechaPedido, dbo.view_FacturaCuerpo.NombreProducto, dbo.view_FacturaCuerpo.PrecioUnidad, 
                      dbo.view_FacturaCuerpo.Cantidad, dbo.view_FacturaCuerpo.SubTotal
FROM         dbo.View_FacturaCabecera CROSS JOIN
                      dbo.view_FacturaCuerpo
GO
/****** Object:  Table [dbo].[Cargos]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cargos](
	[IdCargo] [int] IDENTITY(1,1) NOT NULL,
	[CargoContacto] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Cargos] PRIMARY KEY CLUSTERED 
(
	[CargoContacto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categorías]    Script Date: 08/10/2020 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorías](
	[IdCategoría] [int] NOT NULL,
	[NombreCategoría] [nvarchar](15) NOT NULL,
	[Descripción] [ntext] NULL,
	[Imagen] [image] NULL,
 CONSTRAINT [PK_Categorías] PRIMARY KEY CLUSTERED 
(
	[IdCategoría] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ControlUsuario]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControlUsuario](
	[usuario] [nvarchar](50) NULL,
	[FechaEntrada] [datetime] NULL,
	[FechaSalida] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Niveles]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Niveles](
	[IdNivel] [int] IDENTITY(1,1) NOT NULL,
	[Nivel] [nvarchar](50) NULL,
 CONSTRAINT [PK_Niveles] PRIMARY KEY CLUSTERED 
(
	[IdNivel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedores]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedores](
	[IdProveedor] [int] NOT NULL,
	[NombreCompañía] [nvarchar](40) NOT NULL,
	[NombreContacto] [nvarchar](30) NULL,
	[CargoContacto] [nvarchar](30) NULL,
	[Dirección] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Región] [nvarchar](15) NULL,
	[CódPostal] [nvarchar](10) NULL,
	[País] [nvarchar](15) NULL,
	[Teléfono] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	[Logo] [ntext] NULL,
 CONSTRAINT [PK_Proveedores] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios](
	[usuario] [nvarchar](50) NOT NULL,
	[clave] [nvarchar](50) NULL,
	[IdNivel] [int] NULL,
	[IdEmpleado] [int] NULL,
 CONSTRAINT [PK_usuarios] PRIMARY KEY CLUSTERED 
(
	[usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Boleta]  WITH CHECK ADD  CONSTRAINT [FK_Boleta_Clientes] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[Clientes] ([IdCliente])
GO
ALTER TABLE [dbo].[Boleta] CHECK CONSTRAINT [FK_Boleta_Clientes]
GO
ALTER TABLE [dbo].[Boleta]  WITH CHECK ADD  CONSTRAINT [FK_Boleta_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([IdEmpleado])
GO
ALTER TABLE [dbo].[Boleta] CHECK CONSTRAINT [FK_Boleta_Empleados]
GO
ALTER TABLE [dbo].[Clientes]  WITH CHECK ADD  CONSTRAINT [FK_Clientes_Cargos] FOREIGN KEY([CargoContacto])
REFERENCES [dbo].[Cargos] ([CargoContacto])
GO
ALTER TABLE [dbo].[Clientes] CHECK CONSTRAINT [FK_Clientes_Cargos]
GO
ALTER TABLE [dbo].[ControlUsuario]  WITH CHECK ADD  CONSTRAINT [FK_Control Usuario_usuarios] FOREIGN KEY([usuario])
REFERENCES [dbo].[usuarios] ([usuario])
GO
ALTER TABLE [dbo].[ControlUsuario] CHECK CONSTRAINT [FK_Control Usuario_usuarios]
GO
ALTER TABLE [dbo].[DetallesBoleta]  WITH CHECK ADD  CONSTRAINT [FK_Detalles de Boleta_Boleta] FOREIGN KEY([IdBoleta])
REFERENCES [dbo].[Boleta] ([IdBoleta])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DetallesBoleta] CHECK CONSTRAINT [FK_Detalles de Boleta_Boleta]
GO
ALTER TABLE [dbo].[DetallesBoleta]  WITH CHECK ADD  CONSTRAINT [FK_DetallesBoleta_Boleta] FOREIGN KEY([IdBoleta])
REFERENCES [dbo].[Boleta] ([IdBoleta])
GO
ALTER TABLE [dbo].[DetallesBoleta] CHECK CONSTRAINT [FK_DetallesBoleta_Boleta]
GO
ALTER TABLE [dbo].[DetallesFactura]  WITH CHECK ADD  CONSTRAINT [FK_DetallesFactura_Factura] FOREIGN KEY([IdFactura])
REFERENCES [dbo].[Factura] ([IdFactura])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DetallesFactura] CHECK CONSTRAINT [FK_DetallesFactura_Factura]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_Clientes] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[Clientes] ([IdCliente])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_Clientes]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([IdEmpleado])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_Empleados]
GO
ALTER TABLE [dbo].[usuarios]  WITH CHECK ADD  CONSTRAINT [FK_usuarios_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([IdEmpleado])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[usuarios] CHECK CONSTRAINT [FK_usuarios_Empleados]
GO
ALTER TABLE [dbo].[usuarios]  WITH CHECK ADD  CONSTRAINT [FK_usuarios_Niveles] FOREIGN KEY([IdNivel])
REFERENCES [dbo].[Niveles] ([IdNivel])
GO
ALTER TABLE [dbo].[usuarios] CHECK CONSTRAINT [FK_usuarios_Niveles]
GO
/****** Object:  StoredProcedure [dbo].[listarCategoria]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[listarCategoria]
as 
select* from Categorías
GO
/****** Object:  StoredProcedure [dbo].[login]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[login]
@usuario nVARCHAR(50),
@clave nVARCHAR(50) 
as
select *from usuarios
where usuario=@usuario
and clave=@clave
GO
/****** Object:  StoredProcedure [dbo].[productopornombre]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[productopornombre]
@nombreProducto nvarchar(40)
as
SELECT [IdProducto],
	[NombreProducto],
	[IdProveedor],
	[IdCategoría],
	[CantidadPorUnidad],
	[PrecioUnidad],
	[UnidadesEnExistencia],
	[UnidadesEnPedido],
	[Suspendido],
	[image],
	[imagen]
FROM [Productos]
where NombreProducto like @nombreProducto+'%'
GO
/****** Object:  StoredProcedure [dbo].[Sp_AnularBoleta]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_AnularBoleta]
@IdBoleta int,
@suspendido bit
as
update Boleta set suspendido=@suspendido where IdBoleta=@IdBoleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaDelete]
(
	@IdBoleta int
)

AS

SET NOCOUNT ON

DELETE FROM [Boleta]
WHERE [IdBoleta] = @IdBoleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaDeleteAllByIdCliente]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaDeleteAllByIdCliente]
(
	@IdCliente nvarchar(5)
)

AS

SET NOCOUNT ON

DELETE FROM [Boleta]
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaDeleteAllByIdEmpleado]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaDeleteAllByIdEmpleado]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

DELETE FROM [Boleta]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaInsert]
(
	@IdBoleta int,
	@IdCliente nvarchar(5),
	@IdEmpleado int,
	@FechaPedido smalldatetime,
	@Suspendido bit
)

AS

SET NOCOUNT ON

INSERT INTO [Boleta]
(
	[IdBoleta],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
)
VALUES
(
	@IdBoleta,
	@IdCliente,
	@IdEmpleado,
	@FechaPedido,
	@Suspendido
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaSelect]
(
	@IdBoleta int
)

AS

SET NOCOUNT ON

SELECT [IdBoleta],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Boleta]
WHERE [IdBoleta] = @IdBoleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaSelectAll]

AS

SET NOCOUNT ON

SELECT [IdBoleta],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Boleta]
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaSelectAllByIdCliente]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaSelectAllByIdCliente]
(
	@IdCliente nvarchar(5)
)

AS

SET NOCOUNT ON

SELECT [IdBoleta],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Boleta]
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaSelectAllByIdEmpleado]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaSelectAllByIdEmpleado]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

SELECT [IdBoleta],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Boleta]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_BoletaUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_BoletaUpdate]
(
	@IdBoleta int,
	@IdCliente nvarchar(5),
	@IdEmpleado int,
	@FechaPedido smalldatetime,
	@Suspendido bit
)

AS

SET NOCOUNT ON

UPDATE [Boleta]
SET [IdCliente] = @IdCliente,
	[IdEmpleado] = @IdEmpleado,
	[FechaPedido] = @FechaPedido,
	[Suspendido] = @Suspendido
WHERE [IdBoleta] = @IdBoleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_CargosDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CargosDelete]
(
	@CargoContacto nvarchar(30)
)

AS

SET NOCOUNT ON

DELETE FROM [Cargos]
WHERE [CargoContacto] = @CargoContacto
GO
/****** Object:  StoredProcedure [dbo].[Sp_CargosInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CargosInsert]
(
	@CargoContacto nvarchar(30)
)

AS

SET NOCOUNT ON

INSERT INTO [Cargos]
(
	[CargoContacto]
)
VALUES
(
	@CargoContacto
)

SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[Sp_CargosSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CargosSelect]
(
	@CargoContacto nvarchar(30)
)

AS

SET NOCOUNT ON

SELECT [IdCargo],
	[CargoContacto]
FROM [Cargos]
WHERE [CargoContacto] = @CargoContacto
GO
/****** Object:  StoredProcedure [dbo].[Sp_CargosSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CargosSelectAll]

AS

SET NOCOUNT ON

SELECT [IdCargo],
	[CargoContacto]
FROM [Cargos]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CategoríasDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CategoríasDelete]
(
	@IdCategoría int
)

AS

SET NOCOUNT ON

DELETE FROM [Categorías]
WHERE [IdCategoría] = @IdCategoría
GO
/****** Object:  StoredProcedure [dbo].[Sp_CategoríasInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CategoríasInsert]
(
	@IdCategoría int,
	@NombreCategoría nvarchar(15),
	@Descripción ntext,
	@Imagen image
)

AS

SET NOCOUNT ON

INSERT INTO [Categorías]
(
	[IdCategoría],
	[NombreCategoría],
	[Descripción],
	[Imagen]
)
VALUES
(
	@IdCategoría,
	@NombreCategoría,
	@Descripción,
	@Imagen
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_CategoríasSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CategoríasSelect]
(
	@IdCategoría int
)

AS

SET NOCOUNT ON

SELECT [IdCategoría],
	[NombreCategoría],
	[Descripción],
	[Imagen]
FROM [Categorías]
WHERE [IdCategoría] = @IdCategoría
GO
/****** Object:  StoredProcedure [dbo].[Sp_CategoríasSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CategoríasSelectAll]

AS

SET NOCOUNT ON

SELECT [IdCategoría],
	[NombreCategoría],
	[Descripción],
	[Imagen]
FROM [Categorías]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CategoríasUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_CategoríasUpdate]
(
	@IdCategoría int,
	@NombreCategoría nvarchar(15),
	@Descripción ntext,
	@Imagen image
)

AS

SET NOCOUNT ON

UPDATE [Categorías]
SET [NombreCategoría] = @NombreCategoría,
	[Descripción] = @Descripción,
	[Imagen] = @Imagen
WHERE [IdCategoría] = @IdCategoría
GO
/****** Object:  StoredProcedure [dbo].[Sp_ClientesDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ClientesDelete]
(
	@IdCliente nvarchar(5)
)

AS

SET NOCOUNT ON

DELETE FROM [Clientes]
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_ClientesDeleteAllByCargoContacto]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ClientesDeleteAllByCargoContacto]
(
	@CargoContacto nvarchar(30)
)

AS

SET NOCOUNT ON

DELETE FROM [Clientes]
WHERE [CargoContacto] = @CargoContacto
GO
/****** Object:  StoredProcedure [dbo].[Sp_ClientesInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ClientesInsert]
(
	@IdCliente nvarchar(5),
	@NombreCompañía nvarchar(40),
	@NombreContacto nvarchar(30),
	@CargoContacto nvarchar(30),
	@Dirección nvarchar(60),
	@Ciudad nvarchar(15),
	@Región nvarchar(15),
	@CódPostal nvarchar(10),
	@País nvarchar(15),
	@Teléfono nvarchar(24),
	@Fax nvarchar(24)
)

AS

SET NOCOUNT ON

INSERT INTO [Clientes]
(
	[IdCliente],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax]
)
VALUES
(
	@IdCliente,
	@NombreCompañía,
	@NombreContacto,
	@CargoContacto,
	@Dirección,
	@Ciudad,
	@Región,
	@CódPostal,
	@País,
	@Teléfono,
	@Fax
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_ClientesSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ClientesSelect]
(
	@IdCliente nvarchar(5)
)

AS

SET NOCOUNT ON

SELECT [IdCliente],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax]
FROM [Clientes]
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_ClientesSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ClientesSelectAll]

AS

SET NOCOUNT ON

SELECT [IdCliente],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax]
FROM [Clientes]
GO
/****** Object:  StoredProcedure [dbo].[sp_ClientesSelectAllByCargoContacto]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ClientesSelectAllByCargoContacto]
(
	@CargoContacto nvarchar(30)
)

AS

SET NOCOUNT ON

SELECT [IdCliente],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax]
FROM [Clientes]
WHERE [CargoContacto] = @CargoContacto
GO
/****** Object:  StoredProcedure [dbo].[Sp_ClientesUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ClientesUpdate]
(
	@IdCliente nvarchar(5),
	@NombreCompañía nvarchar(40),
	@NombreContacto nvarchar(30),
	@CargoContacto nvarchar(30),
	@Dirección nvarchar(60),
	@Ciudad nvarchar(15),
	@Región nvarchar(15),
	@CódPostal nvarchar(10),
	@País nvarchar(15),
	@Teléfono nvarchar(24),
	@Fax nvarchar(24)
)

AS

SET NOCOUNT ON

UPDATE [Clientes]
SET [NombreCompañía] = @NombreCompañía,
	[NombreContacto] = @NombreContacto,
	[CargoContacto] = @CargoContacto,
	[Dirección] = @Dirección,
	[Ciudad] = @Ciudad,
	[Región] = @Región,
	[CódPostal] = @CódPostal,
	[País] = @País,
	[Teléfono] = @Teléfono,
	[Fax] = @Fax
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_ControlUsuarioDeleteAllByUsuario]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ControlUsuarioDeleteAllByUsuario]
(
	@usuario nvarchar(50)
)

AS

SET NOCOUNT ON

DELETE FROM [ControlUsuario]
WHERE [usuario] = @usuario
GO
/****** Object:  StoredProcedure [dbo].[Sp_ControlUsuarioInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ControlUsuarioInsert]
(
	@usuario nvarchar(50),
	@FechaEntrada datetime,
	@FechaSalida datetime
)

AS

SET NOCOUNT ON

INSERT INTO [ControlUsuario]
(
	[usuario],
	[FechaEntrada],
	[FechaSalida]
)
VALUES
(
	@usuario,
	@FechaEntrada,
	@FechaSalida
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_ControlUsuarioSelectAllByUsuario]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ControlUsuarioSelectAllByUsuario]
(
	@usuario nvarchar(50)
)

AS

SET NOCOUNT ON

SELECT [usuario],
	[FechaEntrada],
	[FechaSalida]
FROM [ControlUsuario]
WHERE [usuario] = @usuario
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesBoletaDeleteAllByIdBoleta]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesBoletaDeleteAllByIdBoleta]
(
	@IdBoleta int
)

AS

SET NOCOUNT ON

DELETE FROM [DetallesBoleta]
WHERE [IdBoleta] = @IdBoleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesBoletaDeleteAllByIdProducto]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesBoletaDeleteAllByIdProducto]
(
	@IdProducto int
)

AS

SET NOCOUNT ON

DELETE FROM [DetallesBoleta]
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesBoletaInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesBoletaInsert]
(
	@IdBoleta int,
	@IdProducto int,
	@PrecioUnidad money,
	@Cantidad smallint,
	@Descuento real
)

AS

SET NOCOUNT ON

INSERT INTO [DetallesBoleta]
(
	[IdBoleta],
	[IdProducto],
	[PrecioUnidad],
	[Cantidad],
	[Descuento]
)
VALUES
(
	@IdBoleta,
	@IdProducto,
	@PrecioUnidad,
	@Cantidad,
	@Descuento
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesBoletaSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesBoletaSelect]
(
	@IdBoleta int
)

AS

SET NOCOUNT ON

SELECT [IdBoleta],
	[IdProducto],
	[PrecioUnidad],
	[Cantidad],
	[Descuento]
FROM [DetallesBoleta]
WHERE [IdBoleta] = @IdBoleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesBoletaSelectAllByIdProducto]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesBoletaSelectAllByIdProducto]
(
	@IdProducto int
)

AS

SET NOCOUNT ON

SELECT [IdBoleta],
	[IdProducto],
	[PrecioUnidad],
	[Cantidad],
	[Descuento]
FROM [DetallesBoleta]
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesFacturaDeleteAllByIdFactura]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesFacturaDeleteAllByIdFactura]
(
	@IdFactura int
)

AS

SET NOCOUNT ON

DELETE FROM [DetallesFactura]
WHERE [IdFactura] = @IdFactura
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesFacturaDeleteAllByIdProducto]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesFacturaDeleteAllByIdProducto]
(
	@IdProducto int
)

AS

SET NOCOUNT ON

DELETE FROM [DetallesFactura]
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesFacturaInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesFacturaInsert]
(
	@IdFactura int,
	@IdProducto int,
	@PrecioUnidad money,
	@Cantidad smallint,
	@Descuento real
)

AS

SET NOCOUNT ON

INSERT INTO [DetallesFactura]
(
	[IdFactura],
	[IdProducto],
	[PrecioUnidad],
	[Cantidad],
	[Descuento]
)
VALUES
(
	@IdFactura,
	@IdProducto,
	@PrecioUnidad,
	@Cantidad,
	@Descuento
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesFacturaSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesFacturaSelect]
(
	@IdFactura int
)

AS

SET NOCOUNT ON

SELECT [IdFactura],
	[IdProducto],
	[PrecioUnidad],
	[Cantidad],
	[Descuento]
FROM [DetallesFactura]
WHERE [IdFactura] = @IdFactura
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesFacturaSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Sp_DetallesFacturaSelectAll]

AS

SET NOCOUNT ON

SELECT *
FROM DetallesFactura
GO
/****** Object:  StoredProcedure [dbo].[Sp_DetallesFacturaSelectAllByIdProducto]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_DetallesFacturaSelectAllByIdProducto]
(
	@IdProducto int
)

AS

SET NOCOUNT ON

SELECT [IdFactura],
	[IdProducto],
	[PrecioUnidad],
	[Cantidad],
	[Descuento]
FROM [DetallesFactura]
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_EmpleadosDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_EmpleadosDelete]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

DELETE FROM [Empleados]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_EmpleadosInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_EmpleadosInsert]
(
	@IdEmpleado int,
	@Apellidos nvarchar(20),
	@Nombre nvarchar(10),
	@Cargo nvarchar(30),
	@Tratamiento nvarchar(25),
	@FechaNacimiento smalldatetime,
	@FechaContratación smalldatetime,
	@Dirección nvarchar(60),
	@Ciudad nvarchar(15),
	@Región nvarchar(15),
	@CódPostal nvarchar(10),
	@País nvarchar(15),
	@TelDomicilio nvarchar(24),
	@Extensión nvarchar(4),
	@Foto image,
	@Notas ntext,
	@Jefe int
)

AS

SET NOCOUNT ON

INSERT INTO [Empleados]
(
	[IdEmpleado],
	[Apellidos],
	[Nombre],
	[Cargo],
	[Tratamiento],
	[FechaNacimiento],
	[FechaContratación],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[TelDomicilio],
	[Extensión],
	[Foto],
	[Notas],
	[Jefe]
)
VALUES
(
	@IdEmpleado,
	@Apellidos,
	@Nombre,
	@Cargo,
	@Tratamiento,
	@FechaNacimiento,
	@FechaContratación,
	@Dirección,
	@Ciudad,
	@Región,
	@CódPostal,
	@País,
	@TelDomicilio,
	@Extensión,
	@Foto,
	@Notas,
	@Jefe
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_EmpleadosSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_EmpleadosSelect]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

SELECT [IdEmpleado],
	[Apellidos],
	[Nombre],
	[Cargo],
	[Tratamiento],
	[FechaNacimiento],
	[FechaContratación],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[TelDomicilio],
	[Extensión],
	[Foto],
	[Notas],
	[Jefe]
FROM [Empleados]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_EmpleadosSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_EmpleadosSelectAll]

AS

SET NOCOUNT ON

SELECT [IdEmpleado],
	[Apellidos],
	[Nombre],
	[Cargo],
	[Tratamiento],
	[FechaNacimiento],
	[FechaContratación],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[TelDomicilio],
	[Extensión],
	[Foto],
	[Notas],
	[Jefe]
FROM [Empleados]
GO
/****** Object:  StoredProcedure [dbo].[Sp_EmpleadosUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_EmpleadosUpdate]
(
	@IdEmpleado int,
	@Apellidos nvarchar(20),
	@Nombre nvarchar(10),
	@Cargo nvarchar(30),
	@Tratamiento nvarchar(25),
	@FechaNacimiento smalldatetime,
	@FechaContratación smalldatetime,
	@Dirección nvarchar(60),
	@Ciudad nvarchar(15),
	@Región nvarchar(15),
	@CódPostal nvarchar(10),
	@País nvarchar(15),
	@TelDomicilio nvarchar(24),
	@Extensión nvarchar(4),
	@Foto image,
	@Notas ntext,
	@Jefe int
)

AS

SET NOCOUNT ON

UPDATE [Empleados]
SET [Apellidos] = @Apellidos,
	[Nombre] = @Nombre,
	[Cargo] = @Cargo,
	[Tratamiento] = @Tratamiento,
	[FechaNacimiento] = @FechaNacimiento,
	[FechaContratación] = @FechaContratación,
	[Dirección] = @Dirección,
	[Ciudad] = @Ciudad,
	[Región] = @Región,
	[CódPostal] = @CódPostal,
	[País] = @País,
	[TelDomicilio] = @TelDomicilio,
	[Extensión] = @Extensión,
	[Foto] = @Foto,
	[Notas] = @Notas,
	[Jefe] = @Jefe
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaDelete]
(
	@IdFactura int
)

AS

SET NOCOUNT ON

DELETE FROM [Factura]
WHERE [IdFactura] = @IdFactura
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaDeleteAllByIdCliente]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaDeleteAllByIdCliente]
(
	@IdCliente nvarchar(5)
)

AS

SET NOCOUNT ON

DELETE FROM [Factura]
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaDeleteAllByIdEmpleado]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaDeleteAllByIdEmpleado]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

DELETE FROM [Factura]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaInsert]
(
	@IdFactura int,
	@IdCliente nvarchar(5),
	@IdEmpleado int,
	@FechaPedido smalldatetime,
	@Suspendido bit
)

AS

SET NOCOUNT ON

INSERT INTO [Factura]
(
	[IdFactura],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
)
VALUES
(
	@IdFactura,
	@IdCliente,
	@IdEmpleado,
	@FechaPedido,
	@Suspendido
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaSelect]
(
	@IdFactura int
)

AS

SET NOCOUNT ON

SELECT [IdFactura],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Factura]
WHERE [IdFactura] = @IdFactura
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaSelectAll]

AS

SET NOCOUNT ON

SELECT [IdFactura],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Factura]
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaSelectAllByIdCliente]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaSelectAllByIdCliente]
(
	@IdCliente nvarchar(5)
)

AS

SET NOCOUNT ON

SELECT [IdFactura],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Factura]
WHERE [IdCliente] = @IdCliente
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaSelectAllByIdEmpleado]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaSelectAllByIdEmpleado]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

SELECT [IdFactura],
	[IdCliente],
	[IdEmpleado],
	[FechaPedido],
	[Suspendido]
FROM [Factura]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_FacturaUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_FacturaUpdate]
(
	@IdFactura int,
	@IdCliente nvarchar(5),
	@IdEmpleado int,
	@FechaPedido smalldatetime,
	@Suspendido bit
)

AS

SET NOCOUNT ON

UPDATE [Factura]
SET [IdCliente] = @IdCliente,
	[IdEmpleado] = @IdEmpleado,
	[FechaPedido] = @FechaPedido,
	[Suspendido] = @Suspendido
WHERE [IdFactura] = @IdFactura
GO
/****** Object:  StoredProcedure [dbo].[Sp_Ingreso]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_Ingreso]
@USUARIO NVARCHAR (50), @CLAVE NVARCHAR (50), 
@NIVEL INT OUTPUT,@IDEMPLEADO INT OUTPUT
AS
IF LEN (@USUARIO) =0 OR LEN (@CLAVE) =0
BEGIN
    SET @IDEMPLEADO=0
END
ELSE
BEGIN
    SELECT @IDEMPLEADO=IDEMPLEADO, @NIVEL=IdNIVEL FROM USUARIOS WHERE 
    USUARIO=@USUARIO AND CLAVE=@CLAVE
	IF @IDEMPLEADO IS NULL OR @NIVEL IS NULL
	BEGIN
	  SET @NIVEL=0
	  SET @IDEMPLEADO=0
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_NivelesDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_NivelesDelete]
@id int
as
delete from niveles where idnivel=@id
GO
/****** Object:  StoredProcedure [dbo].[Sp_NivelesDelete1]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_NivelesDelete1]
as
delete from niveles where idnivel=7
GO
/****** Object:  StoredProcedure [dbo].[Sp_NivelesDelete2]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_NivelesDelete2]
as
delete from niveles where idnivel=10
GO
/****** Object:  StoredProcedure [dbo].[Sp_NivelesInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_NivelesInsert]
@Nivel nvarchar(50)
as
insert into niveles (Nivel) values(@nivel)
GO
/****** Object:  StoredProcedure [dbo].[Sp_NivelesSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_NivelesSelectAll]
as
select * from Niveles
GO
/****** Object:  StoredProcedure [dbo].[Sp_NumeroBoleta]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_NumeroBoleta]

as
select max(idBoleta) as [Numero] from boleta
GO
/****** Object:  StoredProcedure [dbo].[Sp_NumeroFactura]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[Sp_NumeroFactura]

as
select max(idFactura) as [Numero] from factura
GO
/****** Object:  StoredProcedure [dbo].[Sp_PedidosPorFechaBoleta]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[Sp_PedidosPorFechaBoleta]
@fechainicial datetime,
@fechafinal datetime
as
SELECT     Boleta.IdBoleta, Clientes.NombreCompañía, Empleados.Nombre + ' ' + Empleados.Apellidos AS Empleado, Boleta.FechaPedido, 
                      Boleta.Suspendido,Sum(DetallesBoleta.PrecioUnidad * DetallesBoleta.Cantidad) as [Sub Total],Sum(DetallesBoleta.PrecioUnidad * DetallesBoleta.Cantidad)*19/100 as IGV,
Sum(DetallesBoleta.PrecioUnidad * DetallesBoleta.Cantidad)+Sum(DetallesBoleta.PrecioUnidad * DetallesBoleta.Cantidad)*19/100 as Total
FROM         Clientes INNER JOIN
                      Boleta ON Clientes.IdCliente = Boleta.IdCliente INNER JOIN
                      Empleados ON Boleta.IdEmpleado = Empleados.IdEmpleado INNER JOIN
                      DetallesBoleta ON Boleta.IdBoleta = DetallesBoleta.IdBoleta
where Boleta.fechapedido between @fechainicial and @fechafinal
group by  Boleta.IdBoleta, Clientes.NombreCompañía,Empleados.Nombre,Empleados.Apellidos,Boleta.FechaPedido,Boleta.Suspendido
order by Boleta.fechapedido desc
GO
/****** Object:  StoredProcedure [dbo].[Sp_PedidosPorFechaFactura]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_PedidosPorFechaFactura]
@fechainicial datetime,
@fechafinal datetime
as
SELECT     Factura.IdFactura, Clientes.NombreCompañía, Empleados.Nombre + ' ' + Empleados.Apellidos AS Empleado, Factura.FechaPedido, 
                      Factura.Suspendido,Sum(DetallesFactura.PrecioUnidad * DetallesFactura.Cantidad) as [Sub Total],Sum(DetallesFactura.PrecioUnidad * DetallesFactura.Cantidad)*19/100 as IGV,
Sum(DetallesFactura.PrecioUnidad * DetallesFactura.Cantidad)+Sum(DetallesFactura.PrecioUnidad * DetallesFactura.Cantidad)*19/100 as Total
FROM         Clientes INNER JOIN
                      Factura ON Clientes.IdCliente = Factura.IdCliente INNER JOIN
                      Empleados ON Factura.IdEmpleado = Empleados.IdEmpleado INNER JOIN
                      DetallesFactura ON Factura.IdFactura = DetallesFactura.IdFactura
where Factura.fechapedido between @fechainicial and @fechafinal
group by  Factura.IdFactura, Clientes.NombreCompañía,Empleados.Nombre,Empleados.Apellidos,Factura.FechaPedido,Factura.Suspendido
order by Factura.fechapedido desc
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosDelete]
(
	@IdProducto int
)

AS

SET NOCOUNT ON

DELETE FROM [Productos]
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosDeleteAllByIdCategoría]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosDeleteAllByIdCategoría]
(
	@IdCategoría int
)

AS

SET NOCOUNT ON

DELETE FROM [Productos]
WHERE [IdCategoría] = @IdCategoría
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosDeleteAllByIdProveedor]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosDeleteAllByIdProveedor]
(
	@IdProveedor int
)

AS

SET NOCOUNT ON

DELETE FROM [Productos]
WHERE [IdProveedor] = @IdProveedor
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosInsert]
(
	@IdProducto int,
	@NombreProducto nvarchar(40),
	@IdProveedor int,
	@IdCategoría int,
	@CantidadPorUnidad nvarchar(20),
	@PrecioUnidad money,
	@UnidadesEnExistencia smallint,
	@UnidadesEnPedido smallint,
	@Suspendido bit,
	@image image
)

AS

SET NOCOUNT ON

INSERT INTO [Productos]
(
	[IdProducto],
	[NombreProducto],
	[IdProveedor],
	[IdCategoría],
	[CantidadPorUnidad],
	[PrecioUnidad],
	[UnidadesEnExistencia],
	[UnidadesEnPedido],
	[Suspendido],
	[image]
)
VALUES
(
	@IdProducto,
	@NombreProducto,
	@IdProveedor,
	@IdCategoría,
	@CantidadPorUnidad,
	@PrecioUnidad,
	@UnidadesEnExistencia,
	@UnidadesEnPedido,
	@Suspendido,
	@image
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosSelect]
(
	@IdProducto int
)

AS

SET NOCOUNT ON

SELECT [IdProducto],
	[NombreProducto],
	[IdProveedor],
	[IdCategoría],
	[CantidadPorUnidad],
	[PrecioUnidad],
	[UnidadesEnExistencia],
	[UnidadesEnPedido],
	[Suspendido],
	[image]
FROM [Productos]
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosSelectAll]

AS

SET NOCOUNT ON

SELECT [IdProducto],
	[NombreProducto],
	[IdProveedor],
	[IdCategoría],
	[CantidadPorUnidad],
	[PrecioUnidad],
	[UnidadesEnExistencia],
	[UnidadesEnPedido],
	[Suspendido],
	[image],
		[imagen]
FROM [Productos]
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosSelectAllByIdCategoría]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosSelectAllByIdCategoría]
(
	@IdCategoría int
)

AS

SET NOCOUNT ON

SELECT [IdProducto],
	[NombreProducto],
	[IdProveedor],
	[IdCategoría],
	[CantidadPorUnidad],
	[PrecioUnidad],
	[UnidadesEnExistencia],
	[UnidadesEnPedido],
	[Suspendido],
	[image],
	[imagen]
FROM [Productos]
WHERE [IdCategoría] = @IdCategoría
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosSelectAllByIdProveedor]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosSelectAllByIdProveedor]
(
	@IdProveedor int
)

AS

SET NOCOUNT ON

SELECT [IdProducto],
	[NombreProducto],
	[IdProveedor],
	[IdCategoría],
	[CantidadPorUnidad],
	[PrecioUnidad],
	[UnidadesEnExistencia],
	[UnidadesEnPedido],
	[Suspendido],
	[image]
FROM [Productos]
WHERE [IdProveedor] = @IdProveedor
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProductosUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProductosUpdate]
(
	@IdProducto int,
	@NombreProducto nvarchar(40),
	@IdProveedor int,
	@IdCategoría int,
	@CantidadPorUnidad nvarchar(20),
	@PrecioUnidad money,
	@UnidadesEnExistencia smallint,
	@UnidadesEnPedido smallint,
	@Suspendido bit,
	@image image
)

AS

SET NOCOUNT ON

UPDATE [Productos]
SET [NombreProducto] = @NombreProducto,
	[IdProveedor] = @IdProveedor,
	[IdCategoría] = @IdCategoría,
	[CantidadPorUnidad] = @CantidadPorUnidad,
	[PrecioUnidad] = @PrecioUnidad,
	[UnidadesEnExistencia] = @UnidadesEnExistencia,
	[UnidadesEnPedido] = @UnidadesEnPedido,
	[Suspendido] = @Suspendido,
	[image] = @image
WHERE [IdProducto] = @IdProducto
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProveedoresDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProveedoresDelete]
(
	@IdProveedor int
)

AS

SET NOCOUNT ON

DELETE FROM [Proveedores]
WHERE [IdProveedor] = @IdProveedor
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProveedoresInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProveedoresInsert]
(
	@IdProveedor int,
	@NombreCompañía nvarchar(40),
	@NombreContacto nvarchar(30),
	@CargoContacto nvarchar(30),
	@Dirección nvarchar(60),
	@Ciudad nvarchar(15),
	@Región nvarchar(15),
	@CódPostal nvarchar(10),
	@País nvarchar(15),
	@Teléfono nvarchar(24),
	@Fax nvarchar(24),
	@Logo ntext
)

AS

SET NOCOUNT ON

INSERT INTO [Proveedores]
(
	[IdProveedor],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax],
	[Logo]
)
VALUES
(
	@IdProveedor,
	@NombreCompañía,
	@NombreContacto,
	@CargoContacto,
	@Dirección,
	@Ciudad,
	@Región,
	@CódPostal,
	@País,
	@Teléfono,
	@Fax,
	@Logo
)
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProveedoresSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProveedoresSelect]
(
	@IdProveedor int
)

AS

SET NOCOUNT ON

SELECT [IdProveedor],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax],
	[Logo]
FROM [Proveedores]
WHERE [IdProveedor] = @IdProveedor
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProveedoresSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProveedoresSelectAll]

AS

SET NOCOUNT ON

SELECT [IdProveedor],
	[NombreCompañía],
	[NombreContacto],
	[CargoContacto],
	[Dirección],
	[Ciudad],
	[Región],
	[CódPostal],
	[País],
	[Teléfono],
	[Fax],
	[Logo]
FROM [Proveedores]
GO
/****** Object:  StoredProcedure [dbo].[Sp_ProveedoresUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_ProveedoresUpdate]
(
	@IdProveedor int,
	@NombreCompañía nvarchar(40),
	@NombreContacto nvarchar(30),
	@CargoContacto nvarchar(30),
	@Dirección nvarchar(60),
	@Ciudad nvarchar(15),
	@Región nvarchar(15),
	@CódPostal nvarchar(10),
	@País nvarchar(15),
	@Teléfono nvarchar(24),
	@Fax nvarchar(24),
	@Logo ntext
)

AS

SET NOCOUNT ON

UPDATE [Proveedores]
SET [NombreCompañía] = @NombreCompañía,
	[NombreContacto] = @NombreContacto,
	[CargoContacto] = @CargoContacto,
	[Dirección] = @Dirección,
	[Ciudad] = @Ciudad,
	[Región] = @Región,
	[CódPostal] = @CódPostal,
	[País] = @País,
	[Teléfono] = @Teléfono,
	[Fax] = @Fax,
	[Logo] = @Logo
WHERE [IdProveedor] = @IdProveedor
GO
/****** Object:  StoredProcedure [dbo].[Sp_ReporteBoletaParametro]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sp_ReporteBoletaParametro]
@id int
as
select * from dbo.View_BoletaImpresion where IdBoleta=@id
GO
/****** Object:  StoredProcedure [dbo].[sp_Updateboleta]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_Updateboleta]
@id int,
@suspendido bit
as
--declare @idcliente nvarchar(5)
--set @idcliente=(select idcliente from Clientes where NombreCompañía=@NombreCompañía )

update Boleta set Suspendido=@Suspendido 
where IdBoleta=@id
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCliente]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_UpdateCliente]
@Nombre nvarchar(40),
@NombreCompañía nvarchar(40)
as
--declare @idcliente nvarchar(5)
--set @idcliente=(select idcliente from Clientes where NombreCompañía=@NombreCompañía )

update Clientes set NombreCompañía=@NombreCompañía 
where NombreCompañía =@Nombre
GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosDelete]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_usuariosDelete]
(
	@usuario nvarchar(50)
)

AS

SET NOCOUNT ON

DELETE FROM [usuarios]
WHERE [usuario] = @usuario
GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosDeleteAllByIdEmpleado]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_usuariosDeleteAllByIdEmpleado]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

DELETE FROM [usuarios]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosInsert]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Sp_usuariosInsert]
(
	@usuario nvarchar(50),
	@clave nvarchar(50),
	@IdNivel int,
	@IdEmpleado int
)

AS

SET NOCOUNT ON

INSERT INTO [usuarios]
(
	[usuario],
	[clave],
	[IdNivel],
	[IdEmpleado]
)
VALUES
(
	@usuario,
	@clave,
	@IdNivel,
	@IdEmpleado
)

GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosSelect]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_usuariosSelect]
(
	@usuario nvarchar(50)
)

AS

SET NOCOUNT ON

SELECT [usuario],
	[clave],
	[Nivel],
	[IdEmpleado]
FROM [usuarios]
WHERE [usuario] = @usuario
GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosSelectAll]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_usuariosSelectAll]

AS

SET NOCOUNT ON

SELECT *
FROM [usuarios]
GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosSelectAllByIdEmpleado]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_usuariosSelectAllByIdEmpleado]
(
	@IdEmpleado int
)

AS

SET NOCOUNT ON

SELECT [usuario],
	[clave],
	[Nivel],
	[IdEmpleado]
FROM [usuarios]
WHERE [IdEmpleado] = @IdEmpleado
GO
/****** Object:  StoredProcedure [dbo].[Sp_usuariosUpdate]    Script Date: 08/10/2020 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_usuariosUpdate]
(
	@usuario nvarchar(50),
	@clave nvarchar(50),
	@Nivel int,
	@IdEmpleado int
)

AS

SET NOCOUNT ON

UPDATE [usuarios]
SET usuario=@usuario,
[clave] = @clave,
	[IdNivel] = @Nivel,
	[IdEmpleado] = @IdEmpleado
WHERE [usuario] = @usuario
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[45] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "View_BoletaCabecera"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_BoletaCuerpo"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 121
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2340
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_BoletaImpresion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_BoletaImpresion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "View_FacturaCabecera"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 161
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_FacturaCuerpo"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 147
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_FacturaImpresion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_FacturaImpresion'
GO
