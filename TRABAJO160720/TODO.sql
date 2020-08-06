
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
) 
GO

CREATE TABLE [dbo].[TMP_MOVIDET_2](
	[PROVEEDOR] [nvarchar](255) NULL,
	[Nº FACTURA] [nvarchar](255) NULL,
	[PRODUCTO] [nvarchar](128) NULL,
	[CANTIDAD] [float] NULL,
	[SUBTOTBAS] [numeric](12, 4) NULL,
	[NROMOVI] [numeric](10, 0) NULL,
	[FECHA] [datetime] NULL
) ON [PRIMARY]

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


CREATE procedure SpNroFactura  
as  
SELECT DISTINCT [Nº FACTURA] as nrofactura FROM dbo.Migrar 

GO

CREATE PROC SP_INSERT_TMP_MOVIDET  
  
AS  
DELETE FROM TMP_MOVIDET  
  
INSERT INTO TMP_MOVIDET(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD)  
select FECHA,[PROVEEDOR],[Nº FACTURA] ,PRODUCTO,CANTIDAD     
FROM      
(SELECT FECHA,[PROVEEDOR],[Nº FACTURA],      
[84 OCTANOS],[90 OCTANOS],[97 OCTANOS],[DIESEL B5]              
   FROM Migrar       
) P      
UNPIVOT (CANTIDAD FOR PRODUCTO IN (      
[84 OCTANOS],[90 OCTANOS],[97 OCTANOS],[DIESEL B5]       
)) AS Unpvt      
WHERE CANTIDAD<>0    
  
  
INSERT INTO TMP_MOVIDET(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,  SUBTOTBAS)  
  
select FECHA,[PROVEEDOR],[Nº FACTURA] ,PRODUCTO,SUBTOTAL         
FROM      
(SELECT FECHA,[PROVEEDOR],[Nº FACTURA],      
[84 OCTANOS1],[FISE],[90 OCTANOS1],[FISE1],[97 OCTANOS1],[FISE2],[DIESEL B51],[FISE3]               
   FROM Migrar      
) P      
UNPIVOT (SUBTOTAL FOR PRODUCTO IN (      
[84 OCTANOS1],[FISE],[90 OCTANOS1],[FISE1],[97 OCTANOS1],[FISE2],[DIESEL B51],[FISE3]       
)) AS Unpvt      
WHERE SUBTOTAL<>0      

GO


CREATE  PROCEDURE CUR_TMP_MOVIDET_2                                            
 @VALNROFACTURA  varchar(255),    
  @NROMOVI   varchar(255)                                                
AS                          
                            
DECLARE @PROVEEDOR varchar(255)                                           
DECLARE @NROFACTURA  varchar(255)                         
DECLARE @PRODUCTO  varchar(255)     
DECLARE @CANTIDAD  INT    
DECLARE @SUBTOTBAS  numeric(12,4)      
DECLARE @FECHA DATETIME    
                                                       
DECLARE cClientes_1 CURSOR FOR                            
    
SELECT FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, ISNULL(CANTIDAD,0), SUBTOTBAS FROM TMP_MOVIDET    
 WHERE [Nº FACTURA]=@VALNROFACTURA       
OPEN cClientes_1                                            
FETCH cClientes_1 INTO @FECHA,@PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                             
WHILE (@@FETCH_STATUS = 0 )                                            
                                            
BEGIN                                                          
      
      
    PRINT CONVERT(VARCHAR(50), @CANTIDAD)  
      
IF @PRODUCTO='84 OCTANOS'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'01',@CANTIDAD,@NROMOVI)     
END        
      
IF @PRODUCTO='90 OCTANOS'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'02',@CANTIDAD,@NROMOVI)     
END     
    
IF @PRODUCTO='97 OCTANOS'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'03',@CANTIDAD,@NROMOVI)     
END      
    
IF @PRODUCTO='DIESEL B5'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'04',@CANTIDAD,@NROMOVI)     
END      
    
    
IF @PRODUCTO='84 OCTANOS1'       
BEGIN      
  
  
IF @CANTIDAD=0   
BEGIN   
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'01',1,@SUBTOTBAS,@NROMOVI)     
END  
ELSE  
BEGIN  
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'01',@SUBTOTBAS,@NROMOVI)     
END  
  
  
END     
     
IF @PRODUCTO='90 OCTANOS1'       
BEGIN      
  
IF @CANTIDAD=0   
BEGIN   
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'02',1,@SUBTOTBAS,@NROMOVI)     
END  
ELSE  
BEGIN  
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'02',@SUBTOTBAS,@NROMOVI)     
END  
    
  
END    
    
IF @PRODUCTO='97 OCTANOS1'       
BEGIN      
  
IF @CANTIDAD=0   
BEGIN   
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'03',1,@SUBTOTBAS,@NROMOVI)   
END  
ELSE  
BEGIN  
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'03',@SUBTOTBAS,@NROMOVI)   
END  
  
  
    
END      
    
IF @PRODUCTO='DIESEL B51'       
BEGIN      
  
IF @CANTIDAD=0   
BEGIN   
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'04',1,@SUBTOTBAS,@NROMOVI)     
END  
ELSE  
BEGIN  
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'04',@SUBTOTBAS,@NROMOVI)     
END  
  
END      
     
    
IF @PRODUCTO='FISE'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'06',1,@SUBTOTBAS,@NROMOVI)     END      
    
IF @PRODUCTO='FISE1'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'06',1,@SUBTOTBAS,@NROMOVI)     
END      
    
IF @PRODUCTO='FISE2'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'06',1,@SUBTOTBAS,@NROMOVI)     
END      
    
IF @PRODUCTO='FISE3'       
BEGIN      
INSERT INTO TMP_MOVIDET_2(FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS,NROMOVI)      
VALUES(@FECHA,@PROVEEDOR,@NROFACTURA,'06',1,@SUBTOTBAS,@NROMOVI)     
END      
           
           
          
FETCH cClientes_1 INTO @FECHA,@PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                                             
END                                            
                                            
-- Cierre del cursor                                                                              
CLOSE cClientes_1                                            
                                            
-- Liberar los recursos                                                    
DEALLOCATE cClientes_1 

GO



CREATE  PROCEDURE CUR_INSERT_MOVIDET                                           
 @VALNROFACTURA  varchar(255),    
 @NROMOVI   varchar(255)                                               
AS                          
                            
DECLARE @PROVEEDOR varchar(255)                                           
DECLARE @NROFACTURA  varchar(255)                         
DECLARE @PRODUCTO  varchar(255)     
DECLARE @CANTIDAD  INT    
DECLARE @SUBTOTBAS  numeric(12,4)      
DECLARE @CONTA  INT = 0        
DECLARE @PORCIGV  varchar(255)     
DECLARE @COSTOBAS  numeric(12,4)     
DECLARE @FECHA DATETIME      
                                                       
DECLARE cClientes_2 CURSOR FOR                            
    
SELECT FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO,SUM(ISNULL(CANTIDAD,0)) AS CANTIDAD, SUM(ISNULL(SUBTOTBAS,0)) AS SUBTOTBAS FROM TMP_MOVIDET_2    
WHERE [Nº FACTURA]=@VALNROFACTURA  AND NROMOVI=@NROMOVI    
GROUP BY FECHA,PROVEEDOR, [Nº FACTURA], PRODUCTO    
    
        
OPEN cClientes_2                                            
FETCH cClientes_2 INTO @FECHA,@PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                             
WHILE (@@FETCH_STATUS = 0 )                                            
                                            
BEGIN                                                          
      
      
IF @PRODUCTO='06'       
BEGIN      
SET @PORCIGV=0    
END    
ELSE    
BEGIN      
SET @PORCIGV=18    
END      
     
   PRINT '@NROFACTURAX '  + CONVERT(VARCHAR(50),@NROFACTURA)   
   PRINT '@NROMOVIX '  + CONVERT(VARCHAR(50),@NROMOVI)   
     
SET @COSTOBAS=@SUBTOTBAS/@CANTIDAD    
      
 SET @CONTA=@CONTA+1     
      
      
      
INSERT INTO dbo.MOVIDET(CDALMACEN, CDTIPOMOV, NROMOVI, ITEM, CDARTICULO, PORCIGV, CANTIDAD, COSTOBAS, COSTOEXT, SUBTOTBAS, SUBTOTEXT, COSTOBASANT, COSTOEXTANT, FECDOCUM, FECPROCESO, INOUT, EMITIDO, INVFISI, STOCK, FECVENC)    
VALUES('01','03',@NROMOVI,@CONTA,@PRODUCTO,@PORCIGV,@CANTIDAD,@COSTOBAS,@COSTOBAS/3.20,@SUBTOTBAS,@SUBTOTBAS/3.20,@COSTOBAS,@COSTOBAS/3.20,@FECHA,@FECHA,1,0,0,0,'')    
    
      
FETCH cClientes_2 INTO @FECHA,@PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                                             
END                                            
                                            
-- Cierre del cursor                                                                              
CLOSE cClientes_2                                            
                                            
-- Liberar los recursos                                                                          
DEALLOCATE cClientes_2 

GO

CREATE  PROCEDURE SP_INSERT_MOVICAB                                        
 @VALNROFACTURA  varchar(255),    
 @NROMOVI   varchar(255)                                                  
AS                          
                            
DECLARE @PROVEEDOR varchar(255)                                           
DECLARE @TIPODOC  varchar(255)                         
DECLARE @NROFACTURA  varchar(255)     
DECLARE @CANTIDAD  INT    
DECLARE @FECHA  datetime    
DECLARE @SUBTOTBAS  numeric(12,4)     
DECLARE @SUBTOTEXT  numeric(12,4)     
DECLARE @IGVBAS  numeric(12,4)     
DECLARE @TOTBAS  numeric(12,4)       
                                                                                 
SET @PROVEEDOR = (SELECT DISTINCT PROVEEDOR FROM dbo.Migrar  where [Nº FACTURA]=@VALNROFACTURA)    
SET @TIPODOC = (SELECT DISTINCT TIPODOC FROM dbo.Migrar  where [Nº FACTURA]=@VALNROFACTURA)      
SET @FECHA =(SELECT TOP 1 FECHA FROM dbo.Migrar where [Nº FACTURA]=@VALNROFACTURA ORDER BY FECHA DESC)    
    
SET @SUBTOTBAS=(SELECT SUM(SUBTOTBAS) FROM MOVIDET WHERE NROMOVI =@NROMOVI)    
SET @SUBTOTEXT=(SELECT SUM(SUBTOTEXT) FROM MOVIDET WHERE NROMOVI =@NROMOVI)        
SET @IGVBAS=(1.18-1)*(@SUBTOTBAS)       
SET @TOTBAS=(@SUBTOTBAS+@IGVBAS)      
    
      
INSERT INTO dbo.MOVICAB(CDALMACEN, CDTIPOMOV, NROMOVI, CDPROVEE, CDTIPODOC, INOUT, NRODOC, FECDOCUM, FECPROCESO, CDMONEDA, SUBTOTBAS, SUBTOTEXT, CAMBIO, IGVBAS, IGVEXT, TOTBAS     , TOTEXT       , ALMATRAN, EMITIDO, ESTADO, USERID, PERIODO, EJERCICIO, TRANSF, UPDCOSTO, NROPEDIDO, FECHDESCARGA, FISE, SCOP)    
                    VALUES('01'  ,'03'      ,@NROMOVI,@PROVEEDOR,'01',1   ,@VALNROFACTURA,@FECHA,@FECHA    ,'S'      ,@SUBTOTBAS,@SUBTOTEXT  ,3.2    ,@IGVBAS,@IGVBAS/3.20,@TOTBAS,@TOTBAS/3.20,''       ,0       ,''    ,'2411',''      ,''        ,      0,  
   0,         0,           '',   0,'')    
                      
 UPDATE TIPOMOVI SET  CORRELATIVO=CORRELATIVO + 1  
  WHERE CDTIPOMOV='03'