package com.turkcell;
import java.util.Scanner;
/*
7.05.2023 - Workshop Çalışması
Bir kütüphane yönetim sistemi tasarladığımızı düşünelim.
Bu sistemde yer alacak classları oluşturunuz bu classlar içerisine gerekli alan ve metotları ekleyiniz.

Sistemde olması beklenen temel özellikler (hepsi simüle edilebilir):

Öğrenciler kitap kiralayabilmelidir.
Öğrenciler sisteme kayıt olabilmelidir
Öğrenciler kitap teslim edebilmelidir.
Öğretmenler kitap kiralamada görevli olmalıdır.
Kitap, Öğretmen, Öğrenci için modelleri oluşturup içinde alan ve metotları ekledikten sonra main dosyanızda testlerinizi yapınız.
Tüm özellikler simüle edilebilir yani işlevleri konsola "Kitap kiralandı" gibi textler yazarak sağlamanız yeterlidir.

 */
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.printf("Lütfen Adınızı Giriniz: ");
        String name = scanner.nextLine();
        Student student1 = new Student();
        student1.setName(name);
        System.out.println(name +"İsimli Kullanıcı Kaydedildi. Kullanıcı ID:" +student1.getId());





    }
}