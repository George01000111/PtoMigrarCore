  
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