-- =====================================================================
-- Taj AlAsehaa — Database Schema
-- MySQL 8 / MariaDB 10.5+ compatible. utf8mb4 for full Arabic support.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS tajelsehaa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tajelsehaa;

-- ---------------------------------------------------------------------
-- 1. SERVICES — what the clinic offers
-- ---------------------------------------------------------------------
CREATE TABLE services (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug            VARCHAR(80)  NOT NULL UNIQUE,
  title_ar        VARCHAR(160) NOT NULL,
  title_en        VARCHAR(160) NOT NULL,
  short_desc_ar   VARCHAR(500) NOT NULL,
  short_desc_en   VARCHAR(500) NOT NULL,
  long_desc_ar    TEXT NULL,
  long_desc_en    TEXT NULL,
  icon            VARCHAR(40)  NOT NULL DEFAULT 'medical',
  hero_image      VARCHAR(255) NULL,
  is_featured     TINYINT(1)   NOT NULL DEFAULT 0,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  display_order   INT          NOT NULL DEFAULT 0,
  meta_title      VARCHAR(160) NULL,
  meta_description VARCHAR(320) NULL,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_active_order (is_active, display_order)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. PROGRAMS — packaged treatment plans
-- ---------------------------------------------------------------------
CREATE TABLE programs (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug            VARCHAR(80)  NOT NULL UNIQUE,
  title_ar        VARCHAR(160) NOT NULL,
  title_en        VARCHAR(160) NOT NULL,
  tag_ar          VARCHAR(40)  NULL,
  tag_en          VARCHAR(40)  NULL,
  duration        VARCHAR(80)  NULL,
  description_ar  TEXT NOT NULL,
  description_en  TEXT NOT NULL,
  image           VARCHAR(255) NULL,
  price_sar       DECIMAL(10,2) NULL,
  is_active       TINYINT(1)   NOT NULL DEFAULT 1,
  display_order   INT          NOT NULL DEFAULT 0,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. STAFF — doctors and specialists
-- ---------------------------------------------------------------------
CREATE TABLE staff (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name_ar    VARCHAR(160) NOT NULL,
  full_name_en    VARCHAR(160) NOT NULL,
  title_ar        VARCHAR(120) NULL,
  title_en        VARCHAR(120) NULL,
  bio_ar          TEXT NULL,
  bio_en          TEXT NULL,
  photo           VARCHAR(255) NULL,
  specialties     VARCHAR(500) NULL,
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  display_order   INT NOT NULL DEFAULT 0,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. APPOINTMENTS — booking requests submitted from the site
-- ---------------------------------------------------------------------
CREATE TABLE appointments (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name       VARCHAR(160) NOT NULL,
  phone           VARCHAR(40)  NOT NULL,
  email           VARCHAR(160) NULL,
  service_id      INT UNSIGNED NULL,
  program_id      INT UNSIGNED NULL,
  preferred_date  DATE NULL,
  preferred_time  TIME NULL,
  notes           TEXT NULL,
  status          ENUM('new','contacted','confirmed','completed','cancelled') NOT NULL DEFAULT 'new',
  source          VARCHAR(40)  DEFAULT 'website',
  ip_address      VARCHAR(45)  NULL,
  user_agent      VARCHAR(255) NULL,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE SET NULL,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE SET NULL,
  INDEX idx_status_date (status, created_at)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. CONTACT MESSAGES — generic enquiries
-- ---------------------------------------------------------------------
CREATE TABLE contact_messages (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name   VARCHAR(160) NOT NULL,
  phone       VARCHAR(40)  NULL,
  email       VARCHAR(160) NULL,
  subject     VARCHAR(255) NULL,
  message     TEXT NOT NULL,
  is_read     TINYINT(1) NOT NULL DEFAULT 0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. TESTIMONIALS — patient reviews shown on the homepage
-- ---------------------------------------------------------------------
CREATE TABLE testimonials (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name_ar     VARCHAR(120) NOT NULL,
  name_en     VARCHAR(120) NULL,
  location_ar VARCHAR(120) NULL,
  location_en VARCHAR(120) NULL,
  rating      TINYINT NOT NULL DEFAULT 5,
  quote_ar    TEXT NOT NULL,
  quote_en    TEXT NULL,
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  display_order INT NOT NULL DEFAULT 0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. FAQ
-- ---------------------------------------------------------------------
CREATE TABLE faqs (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  question_ar VARCHAR(255) NOT NULL,
  question_en VARCHAR(255) NULL,
  answer_ar   TEXT NOT NULL,
  answer_en   TEXT NULL,
  category    VARCHAR(60) NULL,
  display_order INT NOT NULL DEFAULT 0,
  is_active   TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 8. SITE SETTINGS — contact info, hours, social links
-- ---------------------------------------------------------------------
CREATE TABLE site_settings (
  setting_key   VARCHAR(80) PRIMARY KEY,
  setting_value TEXT NOT NULL,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 9. ADMIN USERS — for the back-office
-- ---------------------------------------------------------------------
CREATE TABLE admins (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email         VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name     VARCHAR(160) NOT NULL,
  role          ENUM('owner','manager','editor') NOT NULL DEFAULT 'editor',
  is_active     TINYINT(1) NOT NULL DEFAULT 1,
  last_login    TIMESTAMP NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================================================
-- SEED DATA — minimum content to render the homepage
-- =====================================================================

INSERT INTO services (slug, title_ar, title_en, short_desc_ar, short_desc_en, icon, is_featured, display_order) VALUES
('physical-therapy', 'العلاج الطبيعي وإعادة التأهيل', 'Physical Therapy & Rehabilitation',
 'جلسات متطورة لاستعادة الحركة وتقوية العضلات بعد الإصابات، مع برامج مخصصة لكل حالة وفق المعايير الدولية.',
 'Advanced sessions to restore movement and strengthen muscles after injuries.', 'stethoscope', 0, 1),
('pain-management', 'إدارة الألم واستعادة الحركة', 'Pain Management & Mobility',
 'علاج متخصص لتخفيف الألم وتحسين اللياقة الحركية باستخدام أحدث تقنيات العلاج الطبيعي.',
 'Specialized pain relief and mobility treatment with modern PT techniques.', 'pulse', 0, 2),
('umrah-rehab', 'إعادة التأهيل المتخصصة للمعتمرين', 'Pilgrim Rehabilitation',
 'برامج إعادة تأهيل مخصصة للحجاج والمعتمرين، لتخفيف الإجهاد واستعادة النشاط بعد أداء المناسك.',
 'Rehab programs designed for pilgrims after Hajj/Umrah.', 'location', 1, 3),
('advanced-tech', 'تقنيات إعادة التأهيل المتقدمة', 'Advanced Rehab Technology',
 'نستخدم أحدث الأجهزة لضمان نتائج فعالة في دعم المفاصل والعضلات.',
 'We use the latest devices to support joints and muscles.', 'device', 0, 4),
('body-sculpting', 'التنحيف ونحت الجسم', 'Slimming & Body Sculpting',
 'جلسات آمنة لشفط الدهون وتكسير الدهون لنحت الجسم وتحسين المظهر الصحي بدون تدخل جراحي.',
 'Safe non-surgical fat reduction and body contouring.', 'drop', 0, 5),
('cupping', 'العلاج بالحجامة', 'Cupping Therapy',
 'نوفر الحجامة الوقائية والعلاجية لتحفيز الدورة الدموية وتنقية الجسم من السموم.',
 'Preventive and therapeutic cupping using modern methods.', 'cup', 0, 6);

INSERT INTO programs (slug, title_ar, title_en, tag_ar, tag_en, duration, description_ar, description_en, image, display_order) VALUES
('movement-rehab', 'برنامج إعادة التأهيل الحركي', 'Movement Rehabilitation', 'الأكثر طلباً', 'Most Popular', '4-8 weeks',
 'برنامج متكامل لاستعادة الحركة بعد الإصابات والجراحات، يشمل التقييم الأولي، الجلسات العلاجية، والمتابعة.',
 'Integrated movement-recovery program after injury or surgery.',
 'assets/images/program-rehab.svg', 1),
('home-therapy', 'برنامج العلاج الطبيعي المنزلي', 'At-Home Physical Therapy', 'جديد', 'New', 'في منزلك',
 'جلسات علاج طبيعي في منزلك، يقدمها فريقنا المتخصص لراحتك وتسريع التعافي في بيئتك المألوفة.',
 'In-home physical therapy delivered by our specialists.',
 'assets/images/program-home.svg', 2),
('umrah-program', 'برنامج تأهيل المعتمرين', 'Umrah Rehabilitation', 'مخصص', 'Specialized', 'للحجاج والمعتمرين',
 'برنامج متخصص لتخفيف الإجهاد العضلي واستعادة الطاقة بعد أداء العمرة والحج.',
 'Specialized program for post-Umrah/Hajj recovery.',
 'assets/images/program-umrah.svg', 3);

INSERT INTO testimonials (name_ar, location_ar, rating, quote_ar, is_published, display_order) VALUES
('أحمد المطيري', 'المدينة المنورة', 5,
 'عانيت من ألم مزمن في الظهر لسنوات، وبعد جلسات قليلة في تاج الأصحاء بدأت أشعر بفرق حقيقي. الفريق محترف ومتفهم، والنتائج فاقت توقعاتي.', 1, 1),
('سعاد القحطاني', 'عميلة دائمة', 5,
 'كانت تجربتي مع العلاج بعد الإصابة الرياضية مذهلة. التقنيات المستخدمة حديثة جداً وفريق العمل يقدم رعاية شخصية لكل مريض على حدة.', 1, 2),
('خالد العبدلي', 'زائر من الرياض', 5,
 'برنامج تأهيل المعتمرين كان نقلة نوعية بعد العمرة. المكان نظيف، الطاقم لطيف، والأسعار مناسبة جداً مقارنة بجودة الخدمة المقدمة.', 1, 3);

INSERT INTO faqs (question_ar, answer_ar, display_order) VALUES
('ما الذي يميز مركز تاج الأصحاء؟',
 'يتميز تاج الأصحاء بدمج الطب الحديث مع العلاجات الطبيعية والتقليدية مثل الحجامة، لتقديم رعاية شاملة تهدف إلى علاج السبب الجذري للمشكلة، وفق المعايير الماليزية المتميزة في العلاج والتأهيل.', 1),
('ما نوع الحالات التي يمكن علاجها؟',
 'نقدم برامج مخصصة لعلاج آلام المفاصل والعضلات، الإصابات الرياضية، مشاكل الحركة، وإعادة التأهيل بعد الجراحات، بالإضافة إلى جلسات التنحيف، مع خيارات للعلاج المنزلي.', 2),
('هل يقدم المركز جلسات الحجامة؟',
 'نعم، يوفر المركز الحجامة الوقائية والعلاجية باستخدام أساليب طبية حديثة وآمنة تهدف إلى تنشيط الدورة الدموية، إزالة السموم، وتعزيز طاقة الجسم الطبيعية.', 3),
('هل يمكن حجز استشارة قبل البدء؟',
 'بالطبع، يمكنك حجز استشارة مجانية لتقييم حالتك مع أحد المختصين قبل بدء أي جلسة علاجية، عبر زر "احجز استشارتك المجانية" في الموقع.', 4);

INSERT INTO site_settings (setting_key, setting_value) VALUES
('site_name_ar', 'تاج الأصحاء'),
('site_name_en', 'Taj AlAsehaa'),
('phone', '+966573998384'),
('email', 'info@healife-ksa.com'),
('whatsapp', '+966573998384'),
('address_ar', 'المدينة المنورة، المملكة العربية السعودية'),
('address_en', 'Madinah, Saudi Arabia'),
('hours_ar', 'الاثنين – السبت: 10:00 ص – 7:00 م'),
('hours_en', 'Mon–Sat: 10:00 AM – 7:00 PM'),
('instagram', 'https://instagram.com/tajelsehaa'),
('twitter', 'https://twitter.com/tajelsehaa'),
('facebook', 'https://facebook.com/tajelsehaa'),
('tiktok', 'https://tiktok.com/@tajelsehaa');
