SET search_path TO classicmodels, public;


-- no 1
SELECT 
    productcode,
    productname,
    msrp,
    quantityinstock,
    CASE 
        WHEN msrp < 50 AND quantityinstock > 500 THEN 'Ekonomis - Stok Tinggi'
        WHEN msrp < 50 AND quantityinstock <= 500 THEN 'Ekonomis - Stok Rendah'
        WHEN msrp BETWEEN 50 AND 100 THEN 'Harga Menengah'
        WHEN msrp > 100 THEN 'Harga Premium'
    END AS kategori_produk
FROM products
ORDER BY msrp DESC;


-- no 2
SELECT
	productCode AS kode_produk,
	SUM(quantityOrdered) AS total_terjual,
	COUNT (DISTINCT orderNumber) AS jumlah_pesanan
FROM orderDetails
GROUP BY productCode
HAVING SUM (quantityordered) > (
    SELECT AVG(quantityOrdered) FROM orderdetails ) AND
    COUNT (DISTINCT ordernumber) > 10
ORDER BY total_terjual DESC;


-- no 3
SELECT 
    productcode,
    productname,
    quantityinstock,
    msrp
FROM products
WHERE quantityinstock > (SELECT AVG(quantityinstock) FROM products)
  AND msrp > (SELECT AVG(msrp) FROM products)
ORDER BY quantityinstock DESC;


-- no 4
BEGIN;

UPDATE orders 
SET status = 'Pengiriman' 
WHERE ordernumber = 10100;

SAVEPOINT status_pengiriman;

UPDATE orders 
SET status = 'Batal' 
WHERE ordernumber = 10100;

ROLLBACK TO SAVEPOINT status_pengiriman;

COMMIT;


-- no 5
CREATE TABLE anggota (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_anggota VARCHAR(50) NOT NULL,
    kota_domisili VARCHAR(20) NOT NULL
);

CREATE TABLE buku (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    judul_buku VARCHAR(100) NOT NULL,
    genre VARCHAR(20) NOT NULL,
    stok INT DEFAULT 1
);

CREATE TABLE peminjaman (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_anggota INT,
    id_buku INT,
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE,
    denda INT DEFAULT 0,
    CONSTRAINT fk_peminjaman_anggota
		FOREIGN KEY (id_anggota)
		REFERENCES anggota(id),
    CONSTRAINT fk_peminjaman_buku
		FOREIGN KEY (id_buku)
		REFERENCES buku(id)
);

CREATE INDEX index_buku_genre ON buku(genre);
CREATE INDEX index_anggota_kota ON anggota(kota_domisili);






