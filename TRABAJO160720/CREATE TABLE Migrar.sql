USE [BDMIGRAR]
GO

/****** Object:  Table [dbo].[Migrar]    Script Date: 07/24/2020 13:20:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Migrar](
	[Nº] [float] NULL,
	[FECHA] [datetime] NULL,
	[TIPODOC] [nvarchar](255) NULL,
	[PROVEEDOR] [nvarchar](255) NULL,
	[Nº FACTURA] [nvarchar](255) NULL,
	[84 OCTANOS] [float] NULL,
	[90 OCTANOS] [float] NULL,
	[97 OCTANOS] [float] NULL,
	[DIESEL B5] [float] NULL,
	[84 OCTANOS1] [float] NULL,
	[FISE] [float] NULL,
	[90 OCTANOS1] [float] NULL,
	[FISE1] [float] NULL,
	[97 OCTANOS1] [float] NULL,
	[FISE2] [float] NULL,
	[DIESEL B51] [float] NULL,
	[FISE3] [float] NULL
) ON [PRIMARY]

GO


