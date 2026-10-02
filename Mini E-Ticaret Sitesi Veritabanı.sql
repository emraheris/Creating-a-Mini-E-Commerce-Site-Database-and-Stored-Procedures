-- SQL'de Mini E-Ticaret Sitesi Veritabanı Oluşturma ve Prosedür İşlemleri --

-- VERİ TABANI OLUŞTURMA
/* Musteriler Tablosu Oluşturalım */
/* Tables -> New Table */

Column Name	Data Type	Allow Nulls
MusteriID	int		☐ -- > PrimaryKey -> Identity Specification (Yes) -> Is Identity (Yes)
Isim		nvarchar(50)	☐
Soyisim		nvarchar(50)	☐
EmailAdres	nvarchar(100)	☐
Created_at	datetime	☐ -- > General -> Default Value or Binding -> getdate()
Updated_at	datetime	☐ -- > General -> Default Value or Binding -> getdatetime()
-------------------------------------------------------------------------------------------
/* Tabloya Veri Ekleyelim */

INSERT INTO Musteriler(Isim,Soyisim,EmailAdres) VALUES ('EMRAH','ERİŞ','emrahyoutube@gmail.com') -- > (Tabloya veri ekledik)

SELECT * FROM Musteriler -- > (Veri eklenmiş mi diye Müşteriler tablosunu kontrol edelim.)
-------------------------------------------------------------------------------------------
/* MusteriGiris Tablosu Oluşturalım */
/* Tables -> New Table */

Column Name	Data Type	Allow Nulls
MID		int		☐ -- > PrimaryKey 
KullaniciAdi	nvarchar(50)	☐
Sifre		nvarchar(50)	☐
-------------------------------------------------------------------------------------------
/* Urunler Tablosu Oluşturalım */
/* Tables -> New Table */

Column Name	Data Type	Allow Nulls
UrunID		int		☐ -- > PrimaryKey -> Identity Specification (Yes) -> Is Identity (Yes)
Isim		nvarchar(50)	☐
Adet		Int		☐
-------------------------------------------------------------------------------------------
/* Satislar Tablosu Oluşturalım */
/* Tables -> New Table */

Column Name	Data Type	Allow Nulls
SatisID		int		☐ -- > PrimaryKey -> Identity Specification (Yes) -> Is Identity (Yes)
MID		int		☐
UID		Int		☐
SatisAdedi	Int		☐
-------------------------------------------------------------------------------------------
-- Tabloları İlişkilendirme

/* Database Diagrams -> New Database Diagrams -> Add Table(Oluşturduğumuz tüm tabloları ekle) */
/* Musteriler tablosundaki PrimaryKey'i sürükleyip MusteriGiris tablosundaki MID PrimaryKey üzerine bırakırız. */
/* Gelen Tables and Columns tablosunda Ok butonuna basılıp ilişki oluşturulur.*/
/* Musteriler tablosundaki PrimaryKey'i sürükleyip Satislar tablosundaki MID üzerine bırakırız.*/
/* Gelen Tables and Columns tablosunda Ok butonuna basılıp ilişki oluşturulur.*/
/* Urunler tablosundaki PrimaryKey'i sürükleyip Satislar tablosundaki UID üzerine bırakırız.*/
/* Gelen Tables and Columns tablosunda Ok butonuna basılıp ilişki oluşturulur.*/
/* Satislar tablosuna sağ tıklanılır. Check Constraints seçilir. Add butonuna basılıp Satislar tablosu eklenilir. */
/* -> Eklenen Satislar tablosu seçilip yandaki menüden General -> Expression yanındaki ... seçilir. Gelen ekranda */
/* -> Satış Adedi eksi değer almaması için SatisAdedi>0 sorgusu yazılır. Ok basılır.*/
/* Urunler - Adet satırı için de Check Constraints'de 0'dan küçük değer almaması için aynı işlem yapılır.*/
/* MusteriGiris - Sifre satırı için Check Constraints'de 'len(Sifre)>8' yazılarak şifrenin en az 8 karakterli olması istenir.*/
/* Oluşturduğumuz bu diyagramı kaydediyoruz.*/
-------------------------------------------------------------------------------------------
-- Urunler Tablosuna Veri Ekleyelim

INSERT INTO Urunler VALUES ('Çanta',15)
INSERT INTO Urunler VALUES ('Hard Disk',70)
-------------------------------------------------------------------------------------------
-- Müşteri Yeni Kayıt Store Procedure Oluşturma /* Veritabanında saklanan ve gerektiğinde çağrılıp çalıştırılabilen SQL komutlarının 						bir bütünüdür.
						En basit haliyle: “Bu SQL işlemlerini tekrar tekrar yazmak yerine bir kere 							tanımlayayım, gerektiğinde çağırayım. demektir”*/

CREATE OR ALTER PROC SP_Musteri_YeniKayit
(
@Isim nvarchar(50),
@SoyIsim nvarchar(50),
@EmailAdres nvarchar(50),
@KullaniciAdi nvarchar(50),
@Sifre nvarchar(50)
)
AS
BEGIN
	DECLARE @id int -- "Değişken tanımlamak için kullandık"
	INSERT INTO Musteriler(Isim,SoyIsim,EmailAdres) VALUES (@Isim,@SoyIsim,@EmailAdres)
	SET @ID = SCOPE_IDENTITY() -- “Az önce INSERT ettiğim kaydın otomatik olarak oluşturulan ID değerini al ve @ID değişkenine ata"
	IF (@@ROWCOUNT>0) -- "Bu satır üstteki satıra veri girildiyse yani 0'dan büyükse Müşteri Giriş tablosuna geçiş yapar"
	INSERT INTO MusteriGiris(MID,KullaniciAdi,Sifre) VALUES (@ID,@KullaniciAdi,@Sifre)
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz. Gelen pencereden veri girişlerimizi yaparız. Giriş yapıp Ok dedikten sonra Return Value = 0 değeri dönüyorsa kayıt başarılı demektir.*/

/* NOT: Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'a sağ tıklayıp Script Stored Procedure as -> ALTER To -> New Query Editor Window seçeneği seçilir. Bu seçenek bizim oluşturduğumuz tabloyu güncellemek için seçilir. */
-------------------------------------------------------------------------------------------
-- Müşteri Kayıt Düzenle Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Musteri_KayitDuzenle
(
@MusteriID int,
@Isim nvarchar(50),
@SoyIsim nvarchar(50),
@EmailAdres nvarchar(50)
)
AS
BEGIN
	UPDATE Musteriler
	SET
	Isim = @Isim,
	SoyIsim = @SoyIsim,
	EmailAdres = @EmailAdres
	WHERE MusteriID = @MusteriID
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Müşteri Kayıt Sil Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Musteri_KayitSil
AS
BEGIN
	DELETE MusteriGiris WHERE MID = @MusteriID
	DELETE Musteriler WHERE MusteriID = @MusteriID
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Tüm Müşteri Kayıtlarını Görüntüle Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Musteri_KayitlariniGoruntule
AS
BEGIN
	SELECT * FROM Musteriler
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Yalnızca Seçilen Müşteri Kaydını Görüntüle Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Musteri_KayitGoruntule
AS
BEGIN
	SELECT * FROM Musteriler WHERE MusteriID = @MusteriID
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Ürün Kayıt Ekleme Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Urun_YeniKayit(@Isim nvarchar(50),@Adet int)
AS
BEGIN
	INSERT INTO Urunler(Isim,Adet) VALUES (@Isim,@Adet)
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Ürün Kayıt Düzenleme Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Urun_KayitDuzenle(@UrunID int,@Isim nvarchar(50),@Adet int)
AS
BEGIN
	UPDATE Urunler
	SET
	Isim = @Isim,
	Adet = @Adet
	WHERE UrunID = @UrunID
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Ürün Kayıt Silme Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Urun_KayitSilme(@UrunID int)
AS
BEGIN
	DELETE Urunler WHERE UrunID = @UrunID
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Tüm Ürün Kayıtlarını Görüntüleme Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Urun_KayitlariniGoruntule
AS
	SELECT * FROM Urunler

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Yalnızca Seçilen Ürün Kayıtlarını Görüntüleme Store Procedure Oluşturma 

CREATE OR ALTER PROC SP_Urun_KayitGoruntule(@UrunID int)
AS
	SELECT * FROM Urunler WHERE UrunID = @UrunID

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Satış Ekleme İşlemi Store Procedure Oluşturma 

ALTER PROC SP_Satis_KayitEkle(@MID int,@UID int,@SatisAdedi int)
AS
BEGIN
	INSERT INTO Satislar(MID,UID,SatisAdedi) VALUES (@MID,@UID,@SatisAdedi)
UPDATE Urunler
SET
Adet = Adet - @SatisAdedi
WHERE UrunID = @UID
END

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Satış Düzenleme İşlemi Store Procedure Oluşturma 

CREATE PROC SP_Satis_KayitDuzenle(@SatisID int,@MID int,@UID int,@SatisAdedi int)
SET
AS
	UPDATE Satislar
	MID = @MID,
	UID = @UID,
	SatisAdedi = @SatisAdedi 
	WHERE SatisID = @SatisID

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Satış Silme İşlemi Store Procedure Oluşturma 

CREATE PROC SP_Satis_KayitSil(@SatisID int)
AS
	DELETE Satislar WHERE SatisID = @SatisID

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Satış Görüntüleme İşlemi Store Procedure Oluşturma 

CREATE PROCEDURE SP_Satis_KayitlariGoruntule
AS
	SELECT * FROM Satislar

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------
-- Yalnızca Seçilen Satış Kaydını Görüntüleme Store Procedure Oluşturma 

CREATE PROCEDURE SP_Satis_KayitGoruntule
AS
	SELECT * FROM Satislar WHERE SatisID = @SatisID

/* Programmability -> Stored Procedures altında oluşturduğumuz Store Procedure'ı görebiliriz (Refresh). Oluşturulan Store Procedure'umuz hangisi ise ona sağ tıklayıp Execute Store Procedure seçeneğini seçeriz.*/
-------------------------------------------------------------------------------------------

