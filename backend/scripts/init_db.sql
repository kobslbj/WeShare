ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'pwd';
flush privileges;

-- Create the 'weshare' database if it doesn't exist
CREATE DATABASE IF NOT EXISTS weshare;
CREATE DATABASE IF NOT EXISTS weshare_test;

-- 創建資料庫時指定字符集和排序規則
CREATE DATABASE weshare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE weshare_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

use weshare;

-- Set the timezone
SET time_zone = '+8:00';

-- Create the 'user' table if it doesn't exist
CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rating FLOAT,
    image VARCHAR(255),
    phone INT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

-- Create the 'item_tag' ENUM type if it doesn't exist
CREATE TABLE IF NOT EXISTS item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seller_id INT NOT NULL,
    buyers_limit INT NOT NULL,
    num_of_buyers INT,
    title VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    introduction VARCHAR(255) NOT NULL,
    cost INT NOT NULL,
    tag ENUM('食品', '日用品', '衣物', '美妝', '家具', '優惠卷', '其他') NOT NULL,
    costco ENUM('內湖店', '北投店', '中和店', '新莊店', '汐止店', '中壢店', '桃園店', '新竹店', '北台中店', '台中店', '嘉義店', '台南店', '高雄店', '高雄大順店') NOT NULL,
    item_location VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    CONSTRAINT item_seller_id_key FOREIGN KEY (seller_id) REFERENCES user(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    seller_id INT NOT NULL,
    buyer_id INT NOT NULL,
    status ENUM('request', 'agree') NOT NULL,
    CONSTRAINT order_item_id_key FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE,
    CONSTRAINT order_seller_id_key FOREIGN KEY (seller_id) REFERENCES item(seller_id) ON DELETE CASCADE,
    CONSTRAINT order_buyer_id_key FOREIGN KEY (buyer_id) REFERENCES user(id) ON DELETE CASCADE
);

-- Create the 'chat' table if it doesn't exist
CREATE TABLE IF NOT EXISTS chat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message VARCHAR(255),
    CONSTRAINT chat_sender_id_key FOREIGN KEY (sender_id) REFERENCES user(id) ON DELETE CASCADE,
    CONSTRAINT chat_receiver_id_key FOREIGN KEY (receiver_id) REFERENCES user(id) ON DELETE CASCADE
);