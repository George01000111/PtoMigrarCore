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