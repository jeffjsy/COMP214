/* Use these steps to create a procedure that allows a company employee to make corrections to
a product’s assigned name. Review the BB_PRODUCT table and identify the PRODUCT NAME
and PRIMARY KEY columns. The procedure needs two IN parameters to identify the product
ID and supply the new description. This procedure needs to perform only a DML action, so no
OUT parameters are necessary. */

CREATE OR REPLACE PROCEDURE prod_name_sp
    (p_prodid IN bb_product.idproduct%TYPE,
    p_descrip IN bb_product.description%TYPE)
    IS
BEGIN
    UPDATE bb_product
    SET description = p_descrip
    WHERE idproduct = p_prodid;
    COMMIT;
END;
BEGIN
    prod_name_sp(2, 'something different');
END;

/*-------------------------------------------------------
 Follow these steps to create a procedure that allows a company employee to add a new
product to the database. This procedure needs only IN parameters. */
CREATE OR REPLACE PROCEDURE prod_add_sp
    (p_name IN bb_product.productname%TYPE,
    p_descrip IN bb_product.description%TYPE,
    p_image IN bb_product.productimage%TYPE,
    p_price IN bb_product.price%TYPE,
    p_active IN bb_product.active%TYPE)
    IS
BEGIN
    INSERT INTO bb_product (idproduct, productname, description,
    productimage, price, active)
    VALUES (bb_prodid_seq.NEXTVAL, p_name, p_descrip, p_image, p_price,
    p_active);
    COMMIT;
END;
BEGIN
    prod_add_sp('New blend', 'Different blend ', 'image.jpg', 20.50, 1);
END;





