USE [BDMIGRAR]
GO

/****** Object:  Table [dbo].[TMP_MOVIDET]    Script Date: 07/24/2020 13:19:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TMP_MOVIDET](
	[PROVEEDOR] [nvarchar](255) NULL,
	[Nº FACTURA] [nvarchar](255) NULL,
	[PRODUCTO] [nvarchar](128) NULL,
	[CANTIDAD] [float] NULL,
	[SUBTOTBAS] [numeric](12, 4) NULL,
	[FECDOCUM] [datetime] NULL,
	[FECHA] [datetime] NULL
) ON [PRIMARY]

GO


