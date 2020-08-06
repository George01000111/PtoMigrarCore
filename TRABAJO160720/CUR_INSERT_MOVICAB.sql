
SELECT * FROM MOVICAB
WHERE  NROMOVI='778'

SELECT * FROM dbo.Migrar
where [Nº FACTURA]='FE66-0024586'


SELECT * FROM dbo.Migrar
ORDER BY [Nº FACTURA]

SELECT DISTINCT [Nº FACTURA] FROM dbo.Migrar
901

CUR_INSERT_MOVICAB 'FE66-0024587',778

ALTER  PROCEDURE CUR_INSERT_MOVICAB                                    
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
                                                   
DECLARE cClientes_3 CURSOR FOR                        
                                    
SELECT DISTINCT PROVEEDOR,TIPODOC,[Nº FACTURA] FROM dbo.Migrar
where [Nº FACTURA]=@VALNROFACTURA

OPEN cClientes_3                                        
FETCH cClientes_3 INTO @PROVEEDOR,@TIPODOC,@NROFACTURA                        
WHILE (@@FETCH_STATUS = 0 )                                        
                                        
BEGIN                                                      
  
SET @FECHA =(SELECT TOP 1 FECHA FROM dbo.Migrar where [Nº FACTURA]=@NROFACTURA ORDER BY FECHA DESC)

SET @SUBTOTBAS=(SELECT SUM(SUBTOTBAS) FROM MOVIDET WHERE NROMOVI =@NROMOVI)
SET @SUBTOTEXT=(SELECT SUM(SUBTOTEXT) FROM MOVIDET WHERE NROMOVI =@NROMOVI)
 --SET @SUBTOTBAS=ROUND( @TOTBAS/(@VALORIGV),@DECIRESU)    
SET @IGVBAS=(1.18-1)*(@SUBTOTBAS)   
SET @TOTBAS=(@SUBTOTBAS+@IGVBAS)  

    
    --ROUND((@VALORIGV-1)*(@SUBTOTBAS),@DECIRESU)
    --               1.18      9095.59

  
INSERT INTO dbo.MOVICAB(CDALMACEN, CDTIPOMOV, NROMOVI, CDPROVEE, CDTIPODOC, INOUT, NRODOC, FECDOCUM, FECPROCESO, CDMONEDA, SUBTOTBAS, SUBTOTEXT, CAMBIO, IGVBAS, IGVEXT, TOTBAS     , TOTEXT       , ALMATRAN, EMITIDO, ESTADO, USERID, PERIODO, EJERCICIO, TRANSF, UPDCOSTO, NROPEDIDO, FECHDESCARGA, FISE, SCOP)
                    VALUES('01'  ,'03'      ,@NROMOVI,@PROVEEDOR,'01',1   ,@NROFACTURA,@FECHA,@FECHA    ,'S'      ,@SUBTOTBAS,@SUBTOTEXT  ,3.2    ,@IGVBAS,@IGVBAS/3.20,@TOTBAS,@TOTBAS/3.20,''       ,0       ,''    ,'2411',''      ,''        ,      0,        0,         0,           '',   0,'')
  
FETCH cClientes_3 INTO @PROVEEDOR,@TIPODOC,@NROFACTURA                                     
END                                        
                                        
-- Cierre del cursor                                                                          
CLOSE cClientes_3                                        
                                        
-- Liberar los recursos                                                                      
DEALLOCATE cClientes_3 