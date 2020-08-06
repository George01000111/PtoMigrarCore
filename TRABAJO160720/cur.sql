SELECT * FROM dbo.Migrar
where [Nº FACTURA]='FE66-0024586'


SELECT [84 OCTANOS],[90 OCTANOS],[97 OCTANOS],[DIESEL B5] FROM dbo.Migrar
where [Nº FACTURA]='FE66-0024586'



select [PROVEEDOR],[Nº FACTURA] ,PRODUCTO,CANTIDAD   
FROM    
(SELECT [PROVEEDOR],[Nº FACTURA],    
[84 OCTANOS],[90 OCTANOS],[97 OCTANOS],[DIESEL B5]            
   FROM Migrar    
WHERE [Nº FACTURA]='FE66-0024586'    
) P    
UNPIVOT (CANTIDAD FOR PRODUCTO IN (    
[84 OCTANOS],[90 OCTANOS],[97 OCTANOS],[DIESEL B5]     
)) AS Unpvt    
WHERE CANTIDAD<>0    



INSERT INTO TMP_MOVIDET(PROVEEDOR, [Nº FACTURA], PRODUCTO,  SUBTOTBAS)
select [PROVEEDOR],[Nº FACTURA] ,PRODUCTO,SUBTOTAL       
FROM    
(SELECT [PROVEEDOR],[Nº FACTURA],    
[84 OCTANOS1],[FISE],[90 OCTANOS1],[FISE1],[97 OCTANOS1],[FISE2],[DIESEL B51],[FISE3]             
   FROM Migrar    
WHERE [Nº FACTURA]='FE66-0024586'    
) P    
UNPIVOT (SUBTOTAL FOR PRODUCTO IN (    
[84 OCTANOS1],[FISE],[90 OCTANOS1],[FISE1],[97 OCTANOS1],[FISE2],[DIESEL B51],[FISE3]     
)) AS Unpvt    
WHERE SUBTOTAL<>0    



SELECT * FROM dbo.ARTICULO


SELECT PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD, SUBTOTBAS
into TMP_MOVIDET_OK
 FROM TMP_MOVIDET
    
SELECT * FROM TMP_MOVIDET
SELECT * FROM TMP_MOVIDET_OK

DELETE FROM TMP_MOVIDET_OK


CUR_TMP_MOVIDET_OK '01'

ALTER  PROCEDURE CUR_TMP_MOVIDET_OK                                        
 @CODEMPRESA  varchar(255)                                            
AS                      
                        
DECLARE @PROVEEDOR varchar(255)                                       
DECLARE @NROFACTURA  varchar(255)                     
DECLARE @PRODUCTO  varchar(255) 
DECLARE @CANTIDAD  INT
DECLARE @SUBTOTBAS  numeric(12,4)  
                                                   
DECLARE cClientes CURSOR FOR                        
                                    


SELECT PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD, SUBTOTBAS FROM TMP_MOVIDET
    
OPEN cClientes                                        
FETCH cClientes INTO @PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                         
WHILE (@@FETCH_STATUS = 0 )                                        
                                        
BEGIN                                                      
  
IF @PRODUCTO='90 OCTANOS'   
BEGIN  
INSERT INTO TMP_MOVIDET_OK(PROVEEDOR, [Nº FACTURA], PRODUCTO, CANTIDAD)  
VALUES(@PROVEEDOR,@NROFACTURA,'02',@CANTIDAD) 
END  

IF @PRODUCTO='90 OCTANOS1'   
BEGIN  
INSERT INTO TMP_MOVIDET_OK(PROVEEDOR, [Nº FACTURA], PRODUCTO, SUBTOTBAS)  
VALUES(@PROVEEDOR,@NROFACTURA,'02',@SUBTOTBAS) 
END  


IF @PRODUCTO='FISE1'   
BEGIN  
INSERT INTO TMP_MOVIDET_OK(PROVEEDOR, [Nº FACTURA], PRODUCTO,CANTIDAD, SUBTOTBAS)  
VALUES(@PROVEEDOR,@NROFACTURA,'06',1,@SUBTOTBAS) 
END  

       
      
FETCH cClientes INTO @PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                                         
END                                        
                                        
-- Cierre del cursor                                                                          
CLOSE cClientes                                        
                                        
-- Liberar los recursos                                                                      
DEALLOCATE cClientes 


SELECT PROVEEDOR, [Nº FACTURA], PRODUCTO,SUM(ISNULL(CANTIDAD,0)) AS CANTIDAD, SUM(ISNULL(SUBTOTBAS,0)) AS SUBTOTBAS FROM TMP_MOVIDET_OK
GROUP BY PROVEEDOR, [Nº FACTURA], PRODUCTO



INSERT INTO dbo.MOVIDET(CDALMACEN, CDTIPOMOV, NROMOVI, ITEM, CDARTICULO, PORCIGV, CANTIDAD, COSTOBAS, COSTOEXT, SUBTOTBAS, SUBTOTEXT, COSTOBASANT, COSTOEXTANT, FECDOCUM, FECPROCESO, INOUT, EMITIDO, TSTAMP, INVFISI, STOCK, FECVENC)


SELECT * FROM dbo.TIPOMOVI WHERE CDTIPOMOV='03'


SELECT * FROM MOVIDET

CUR_INSERT_MOVIDET '01'
300001607


SELECT * FROM MOVIDET
WHERE NROMOVI ='300001607'


ALTER  PROCEDURE CUR_INSERT_MOVIDET                                       
 @CODEMPRESA  varchar(255)                                            
AS                      
                        
DECLARE @PROVEEDOR varchar(255)                                       
DECLARE @NROFACTURA  varchar(255)                     
DECLARE @PRODUCTO  varchar(255) 
DECLARE @CANTIDAD  INT
DECLARE @SUBTOTBAS  numeric(12,4)  
DECLARE @CONTA  INT = 0    
DECLARE @PORCIGV  varchar(255) 
DECLARE @COSTOBAS  numeric(12,4) 
                                                   
DECLARE cClientes CURSOR FOR                        
                                    


SELECT PROVEEDOR, [Nº FACTURA], PRODUCTO,SUM(ISNULL(CANTIDAD,0)) AS CANTIDAD, SUM(ISNULL(SUBTOTBAS,0)) AS SUBTOTBAS FROM TMP_MOVIDET_OK
GROUP BY PROVEEDOR, [Nº FACTURA], PRODUCTO

    
OPEN cClientes                                        
FETCH cClientes INTO @PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                         
WHILE (@@FETCH_STATUS = 0 )                                        
                                        
BEGIN                                                      
  
  
IF @PRODUCTO='02'   
BEGIN  
SET @PORCIGV=18
END
ELSE
BEGIN  
SET @PORCIGV=0
END  
 
SET @COSTOBAS=@SUBTOTBAS/@CANTIDAD
  
 SET @CONTA=@CONTA+1 
  
INSERT INTO dbo.MOVIDET(CDALMACEN, CDTIPOMOV, NROMOVI, ITEM, CDARTICULO, PORCIGV, CANTIDAD, COSTOBAS, COSTOEXT, SUBTOTBAS, SUBTOTEXT, COSTOBASANT, COSTOEXTANT, FECDOCUM, FECPROCESO, INOUT, EMITIDO, INVFISI, STOCK, FECVENC)
VALUES('01','03','300001607',@CONTA,@PRODUCTO,@PORCIGV,@CANTIDAD,@COSTOBAS,@COSTOBAS/3.20,@SUBTOTBAS,@SUBTOTBAS/3.20,@COSTOBAS,@COSTOBAS/3.20,'01/07/2015','01/07/2015',1,0,0,0,'')

  
FETCH cClientes INTO @PROVEEDOR,@NROFACTURA,@PRODUCTO,@CANTIDAD,@SUBTOTBAS                                         
END                                        
                                        
-- Cierre del cursor                                                                          
CLOSE cClientes                                        
                                        
-- Liberar los recursos                                                                      
DEALLOCATE cClientes 


SELECT * FROM MOVICAB
WHERE  NROMOVI='300001607'

SELECT * FROM dbo.Migrar
where [Nº FACTURA]='FE66-0024586'



CUR_INSERT_MOVICAB '01'

ALTER  PROCEDURE CUR_INSERT_MOVICAB                                    
 @CODEMPRESA  varchar(255)                                            
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
                                                   
DECLARE cClientes CURSOR FOR                        
                                    
SELECT PROVEEDOR,TIPODOC,[Nº FACTURA],FECHA FROM dbo.Migrar
where [Nº FACTURA]='FE66-0024586'

OPEN cClientes                                        
FETCH cClientes INTO @PROVEEDOR,@TIPODOC,@NROFACTURA,@FECHA                        
WHILE (@@FETCH_STATUS = 0 )                                        
                                        
BEGIN                                                      
  

SET @SUBTOTBAS=(SELECT SUM(SUBTOTBAS) FROM MOVIDET WHERE NROMOVI ='300001607')
SET @SUBTOTEXT=(SELECT SUM(SUBTOTBAS) FROM MOVIDET WHERE NROMOVI ='300001607')
 --SET @SUBTOTBAS=ROUND( @TOTBAS/(@VALORIGV),@DECIRESU)    
SET @IGVBAS=(1.18-1)*(@SUBTOTBAS)   
SET @TOTBAS=(@SUBTOTBAS+@IGVBAS)  

    
    --ROUND((@VALORIGV-1)*(@SUBTOTBAS),@DECIRESU)
    --               1.18      9095.59

  
INSERT INTO dbo.MOVICAB(CDALMACEN, CDTIPOMOV, NROMOVI, CDPROVEE, CDTIPODOC, INOUT, NRODOC, FECDOCUM, FECPROCESO, CDMONEDA, SUBTOTBAS, SUBTOTEXT, CAMBIO, IGVBAS, IGVEXT, TOTBAS     , TOTEXT       , ALMATRAN, EMITIDO, ESTADO, USERID, PERIODO, EJERCICIO, TRANSF, UPDCOSTO, NROPEDIDO, FECHDESCARGA, FISE, SCOP)
                    VALUES('01'  ,'03'      ,300001607,@PROVEEDOR,'01',1   ,@NROFACTURA,@FECHA,@FECHA    ,'S'      ,@SUBTOTBAS,@SUBTOTEXT  ,3.2    ,@IGVBAS,@IGVBAS/3.20,@TOTBAS,@TOTBAS/3.20,''       ,0       ,''    ,'2411',''      ,''        ,      0,        0,         0,           '',   0,'')
  
FETCH cClientes INTO @PROVEEDOR,@TIPODOC,@NROFACTURA,@FECHA                                      
END                                        
                                        
-- Cierre del cursor                                                                          
CLOSE cClientes                                        
                                        
-- Liberar los recursos                                                                      
DEALLOCATE cClientes 