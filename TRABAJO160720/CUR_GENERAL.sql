
SELECT DISTINCT [Nº FACTURA] FROM dbo.Migrar


FC009-0001708

 


SELECT * FROM dbo.Migrar
WHERE [Nº FACTURA]='FC009-0001708'

SELECT * FROM TMP_MOVIDET
WHERE [Nº FACTURA]='FC009-0001708' 

SELECT * FROM TMP_MOVIDET_OK
WHERE [Nº FACTURA]='FC009-0001708' AND NROMOVI='300005690'

SELECT * FROM MOVICAB
WHERE NRODOC ='FC009-0001708' AND NROMOVI='300005690'

SELECT * FROM MOVIDET
WHERE NROMOVI ='300005690'




2016-09-08 00:00:00.000

BDMIGRAR
BDMIGRAR

-13310.0000
CUR_GENERAL

BDMIGRAR
ALTER  PROCEDURE CUR_GENERAL                                       
                                         
AS                      
                              
DECLARE @NROFACTURA  varchar(255)                     
DECLARE @NROMOVI  numeric(10,0) 
                                                   
DECLARE cClientes_0 CURSOR FOR                        
                                    
SELECT DISTINCT [Nº FACTURA] FROM dbo.Migrar

OPEN cClientes_0                                         
FETCH cClientes_0  INTO @NROFACTURA                         
WHILE (@@FETCH_STATUS = 0 )                                        
                                        
BEGIN                                                      
  
SET @NROMOVI =(SELECT CORRELATIVO FROM dbo.TIPOMOVI WHERE CDTIPOMOV='03')
  
EXEC CUR_TMP_MOVIDET_OK @NROFACTURA,@NROMOVI
EXEC CUR_INSERT_MOVIDET @NROFACTURA,@NROMOVI
EXEC CUR_INSERT_MOVICAB @NROFACTURA,@NROMOVI 
  
  
  UPDATE TIPOMOVI SET  CORRELATIVO=CORRELATIVO + 1
  WHERE CDTIPOMOV='03'
FETCH cClientes_0  INTO @NROFACTURA                                         
END                                        
                                        
-- Cierre del cursor                                                                          
CLOSE cClientes_0                                         
                                        
-- Liberar los recursos                                                                      
DEALLOCATE cClientes_0  
