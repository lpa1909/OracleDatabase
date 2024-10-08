-- create table
create table ANLP_NHANVIEN(
    MaNV varchar2(10) not null,
    HoNV varchar2(50) not null,
    TenLot varchar2(50) not null,
    TenNV varchar2(50) not null,
    ngaysinh date,
    phai varchar2(3) not null,
    diachi varchar2(100),
    ma_nql varchar2(10),
    phong varchar2(10),
    luong number,
    constraint pk_nv primary key (MaNV),
    constraint fk_nv_pb foreign key (phong) references ANLP_PHONGBAN(MaPHG)
);

create table ANLP_PHONGBAN (
    MaPHG varchar2(10) primary key not null,
    TenPHG varchar2(50) not null,
    TrPHG varchar2(50),
    NG_NhanChuc date
);

CREATE TABLE ANLP_PHANCONG (
    MaNV VARCHAR2(10) NOT NULL,
    MaDA VARCHAR2(10) NOT NULL,
    Thoigian VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_phancong PRIMARY KEY (MaNV, MaDA),
    CONSTRAINT fk_phancong_nv FOREIGN KEY (MaNV) REFERENCES ANLP_NHANVIEN(MaNV),
    CONSTRAINT fk_phancong_da FOREIGN KEY (MaDA) REFERENCES ANLP_DEAN(MaDA)
);

create table Dean(
  MaDa varchar2(10) not null,
  Tenda varchar2(50) not null,
  phong varchar2(10) not null,
  NamThucHien varchar2(10) not null
);
-- add pk or fk between to table
ALTER TABLE ANLP_DEAN ADD CONSTRAINT pk_mada PRIMARY KEY (MaDA);

alter table ANLP_DEAN add constraint fk_d_pb foreign key (phong) references ANLP_PHONGBAN(MaPHG);

-- insert data
insert into ANLP_NHANVIEN values
(008, 'Tran', 'Hong', 'Minh', localtimestamp, 'Nu', 'Ha Noi', '', 'NC', 2500000);
commit;

insert into ANLP_PHONGBAN (MaPHG, TenPHG, TrPHG)  values
('ST', 'Sang Tao', '004');
commit;

insert into ANLP_DEAN values
('DT002', 'Dao tao 2', 'DH', '2004');
commit;

insert into ANLP_PHANCONG values
(008, 'DT001', '10,5');
commit;

-- truy van sql
update ANLP_NHANVIEN set TenNV = 'Nam', HoNV = 'Luong' where MaNV = 2;

select * from ANLP_NHANVIEN;

create view TrucThuoc
as select MaNV, HoNV, TenNV, TenPHG from ANLP_NHANVIEN nv, ANLP_PHONGBAN p where nv.phong = p.TenPHG and nv.phong = 5;

select * from ANLP_NHANVIEN where To_Number(TO_CHAR(ngaysinh, 'yyyy')) between 2021 and 2024;

select n.MaNV, n.TenNV, p.TenPHG, n.luong from ANLP_NHANVIEN n, ANLP_PHONGBAN p
where n.phong = p.TenPHG
and n.luong between 2500000 and 3000000;

select * from ANLP_NHANVIEN
where ma_nql is not null;

select * from ANLP_NHANVIEN where TenLot like 'Ngoc%';

drop view TrucThuoc;

select * from ANLP_PHANCONG;

alter table ANLP_PHANCONG add Thoigian Number; commit;

SELECT * FROM ANLP_NHANVIEN WHERE MaNV = :DEPT_NUMBER;

select * from ANLP_NHANVIEN where phong in ('NC');

SELECT *
FROM ANLP_NHANVIEN
WHERE NOT EXISTS (SELECT 1 FROM ANLP_PHONGBAN WHERE ANLP_NHANVIEN.phong = ANLP_PHONGBAN.MaPHG);

-- group by
select luong, COUNT(luong) from ANLP_NHANVIEN group by luong;

-- tim tong luong, luong lon nhat, luong it nhat va luong trung binh cua cac nhan vien
select sum(luong), max(luong), min(luong), avg(luong) from ANLP_NHANVIEN;

-- tim tong luong, luong lon nhat, luong it nhat, va luong trung binhcua cac nhan vien phong nghien cuu
select n.phong, p.TenPHG, sum(n.luong), max(n.luong), min(n.luong), avg(n.luong)
from ANLP_NHANVIEN n, ANLP_PHONGBAN p
where n.phong = p.MaPHG and n.phong LIKE 'NC%' group by p.TenPHG, n.phong;

-- tim tong so luong nhan vien
select count(*) from ANLP_NHANVIEN;


-- cho biet ten tung phong ban va tong so nhan vien, luong trung binh cua phong tren 2000000
select p.TenPHG, COUNT(*)so_luong_nhanvien, avg(n.luong)luong_tb
from ANLP_NHANVIEN n, ANLP_PHONGBAN p
where n.phong = p.MaPHG
group by p.TenPHG
having avg(n.luong) > 2000000;

-- liet ke nhan vien co so gio lam viec nhieu nhat cong ty
SELECT n.MaNV, n.TenNV, SUM(p.Thoigian) thoi_gian_lam_viec
FROM ANLP_NHANVIEN n, ANLP_PHANCONG p
WHERE n.MaNV = p.MaNV
GROUP BY n.MaNV, n.TenNV
HAVING SUM(p.Thoigian) >= ALL(SELECT SUM(Thoigian) FROM ANLP_PHANCONG GROUP BY MaNV);

-- ngon ngu dieu khien du lieu



