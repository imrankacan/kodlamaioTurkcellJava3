-- Database: northwind

-- DROP DATABASE IF EXISTS northwind;

CREATE DATABASE northwind
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Turkish_Turkey.1254'
    LC_CTYPE = 'Turkish_Turkey.1254'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


--10. Fiyatı 30 dan büyük kaç ürün var?
select count(products) as "ürün sayısı" from products where unit_price>30

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select lower(substring(product_name, 1, 1)) as isim, unit_price as fiyat from products order by unit_price desc

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
select employee_id,CONCAT(last_name, ' ', first_name) AS full_name,title from employees

--13. Region alanı NULL olan kaç tedarikçim var?
select count(suppliers) as "tedarikçi" from suppliers where region is not null

--14. a.Null olmayanlar?
	
--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select product_id,CONCAT('TR ', upper(product_name)) as ürün_adı from products


--16. Fiyatı 20den küçük ürünlerin adının başına TR ekle
select product_id,CONCAT('TR ', upper(product_name)) as ürün_adı,unit_price 
from products 
where unit_price<20 order by unit_price

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

select product_name, unit_price
from products
where unit_price = (select max(unit_price) from products)

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price
from products order by unit_price desc limit 10
	
--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name,unit_price from products where unit_price>(select avg(unit_price) from products )

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select sum(unit_price*units_in_stock)from products where units_in_stock>0

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select count(discontinued)  as durdurulan_ürün from products where discontinued=0
select count(discontinued)  as mevcut_ürün from products where discontinued=1

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
select product_id,product_name,category_name,unit_price,units_in_stock from products p
inner join Categories c on c.category_id=p.category_id

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select  p.category_id, avg(p.unit_price) as ortalama_fiyat
from products p
group by p.category_id;

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select p.product_name, c.category_name, p.unit_price
from products p
inner join Categories c on c.category_id = p.category_id
where p.unit_price = (select max(unit_price) from products)

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name
from products p
inner join Categories c  on c.category_id = p.category_id
inner join suppliers s on s.supplier_id=p.supplier_id
where p.unit_price = (select max(unit_price) from products)

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id,p.product_name,s.company_name,s.phone,p.units_in_stock from products p
inner join suppliers s on s.supplier_id=p.supplier_id where units_in_stock=0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select o.ship_address, e.first_name, e.last_name,o.order_date
from orders o
join employees e on o.employee_id = e.employee_id
where extract(year from o.order_date) = 1998 and extract(month from o.order_date) = 3;

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(order_date) as toplam_sipariş_sayısı from orders where extract(year from order_date)=1997

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(order_date) as toplam_sipariş_sayısı from orders where extract(year from order_date)=1998 and ship_city='London'

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name, c.phone, o.order_date from orders o
join customers c  on o.customer_id = c.customer_id
where extract(year from order_date)=1997

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select*from orders where freight>40

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select o.ship_city,c.contact_name from orders o
inner join customers c on c.customer_id=o.customer_id
where freight>40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select o.order_date, concat(upper(e.first_name), upper(e.last_name)) as employee_name, e.city
from orders o
join employees e on o.employee_id = e.employee_id
where extract(year from o.order_date) = 1997;

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select c.contact_name, replace(replace(replace(replace(replace(c.phone, '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')
as phone from customers c where c.customer_id in 
(select o.customer_id from orders o where DATE_PART('year', o.order_date) = 1997);

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date, c.contact_name, e.first_name , e.last_name from orders o
join employees e on e.employee_id=o.employee_id
join customers c on c.customer_id=o.customer_id;

--36. Geciken siparişlerim?
select * from orders where required_date < shipped_date
		
--37. Geciken siparişlerimin tarihi, müşterisinin adı
select o.order_date, c.contact_name 
from orders o 
join customers c on o.customer_id = c.customer_id 
where required_date < shipped_date
		
--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id
where o.order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

select p.product_name, s.contact_name
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join suppliers s on s.supplier_id=p.product_id
where o.order_id = 10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, count(*) as quantity
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
where o.employee_id = 3 and extract(year from o.order_date) = 1997
group by p.product_name;

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, concat(e.first_name, ' ', e.last_name) as employee_name
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join employees e on o.employee_id = e.employee_id
where extract(year from o.order_date) = 1997
group by e.employee_id, employee_name
order by count(*) desc
limit 1;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select employee_id, first_name, last_name from (select o.employee_id, e.first_name, e.last_name, count(*) as total_sales
from orders o join employees e on o.employee_id = e.employee_id where DATE_PART('year', o.order_date) = 1997
group by o.employee_id, e.first_name, e.last_name) as sales order by total_sales desc limit 1;

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name
from products p
join categories c on c.category_id = p.category_id
where p.unit_price = (select max(unit_price) from products)

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.last_name, e.first_name, o.order_date, o.order_id
from orders o
join employees e on e.employee_id = o.employee_id
order by o.order_date

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(p.unit_price) as ortalama_fiyat, o.order_id
from orders o
join order_details od on od.order_id = o.order_id
join products p on p.product_id = od.product_id
group by o.order_id
order by o.order_id desc
limit 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity) as toplam_satis_miktari
from orders o
join order_details od on od.order_id = o.order_id
join products p on p.product_id = od.product_id
join categories c on c.category_id = p.category_id
where extract(month from o.order_date) = 1
group by p.product_name, c.category_name;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select*from orders where freight>(select avg(freight) from orders)

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select c.category_name, s.contact_name, p.product_name
from products p
join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id
where p.units_on_order = (select max(units_on_order) from products);

--49. Kaç ülkeden müşterim var
select count(distinct country) as country_count
from customers

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(od.quantity * od.unit_price) as total_sales 
from orders o join order_details od on o.order_id = od.order_id
where o.employee_id = 3 and o.order_date >= DATE_TRUNC('month', current_date) - INTERVAL '1 month';

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity 
from order_details od join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id where od.order_id = 10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.company_name 
from order_details od join products p on od.product_id = p.product_id
join suppliers s on p.supplier_id = s.supplier_id where od.order_id = 10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity 
from orders o join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id where o.employee_id = 3 and extract(year from o.order_date) = 1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select o.employee_id, e.first_name, e.last_name 
from orders o join employees e on o.employee_id = e.employee_id
where extract(year from o.order_date) = 1997 group by o.employee_id, e.first_name, e.last_name
order by count(o.order_id) desc limit 1;

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select o.employee_id, e.first_name, e.last_name 
from orders o join employees e on o.employee_id = e.employee_id
where extract(year from o.order_date) = 1997 group by o.employee_id, e.first_name, e.last_name
order by count(o.order_id) desc limit 1;

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name 
from products p join categories c ON p.category_id = c.category_id
order by p.unit_price desc limit 1;

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id 
from orders o join employees e on o.employee_id = e.employee_id
order by o.order_date;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(od.unit_price) as average_price, o.order_id from order_details od join orders o on od.order_id = o.order_id
group by o.order_id order by o.order_date desc limit 5

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity) as total_sales from orders o 
join order_details od on o.order_id = od.order_id join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id where extract(month from o.order_date) = 1
group by p.product_name, c.category_name

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir? 
select * from orders where order_id in (select order_id from order_details 
where quantity > (select avg(quantity) from order_details))

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, s.company_name FROM products p JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id WHERE p.product_id = (SELECT product_id FROM order_details
GROUP BY product_id ORDER BY SUM(quantity) DESC LIMIT 1)

--62. Kaç ülkeden müşterim var
select count(distinct country) as customer_count from customers

--63. Hangi ülkeden kaç müşterimiz var
select country, count(*) as customer_count from customers group by country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(od.quantity * od.unit_price) as total_sales from orders o join order_details od on o.order_id = od.order_id
where o.employee_id = 3 and o.order_date >= '2023-01-01'

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(od.quantity * od.unit_price) as total_revenue from orders o join order_details od on o.order_id = od.order_id
where od.product_id = 10 and o.order_date >= current_date - INTERVAL '3 months'

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id, CONCAT(e.first_name, ' ', e.last_name) as employee_name, count(*) as total_orders
from employees e join orders o on e.employee_id = o.employee_id group by e.employee_id, employee_name

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select customer_id, contact_name
from customers
where customer_id not in (
select distinct customer_id
from orders

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_name,address,country,city 
from customers 
where country like 'Brazil'

--69. Brezilya’da olmayan müşteriler
select company_name,contact_name,address,country,city 
from customers 
where country not like 'Brazil'

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers where country in('Spain','Germany','France')

--71. Faks numarasını bilmediğim müşteriler
select*from customers where fax is null

--72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers where city in('London','Paris')

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers where city like 'México D.F.' and contact_title like 'Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name,unit_price from products where product_name like 'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date from employees where first_name like 'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select* from customers where company_name like '%Restaurant%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name,unit_price from products where unit_price between 50 and 100

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
--80. Faks numarasını bilmediğim müşteriler



