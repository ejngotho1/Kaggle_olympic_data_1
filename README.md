# Kaggle_olympic_data_1

### 11.  Fetch the top 5 athletes who have won the most gold medals.

--Select * From [dbo].[athlete_events]

![image](https://user-images.githubusercontent.com/57301554/151046611-12b0f8d4-a6d0-49d1-8c95-c38c01e69175.png)
![image](https://user-images.githubusercontent.com/57301554/151046772-61b41bcf-8055-419e-9861-d37cedc9ba20.png)

##### Michael Phelps has won the most Gold medals since the games started in 1896
##### Ties have been factored using DENSE_RANK window function

### 12. Top 5 athletes who have won the most medals (gold/silver/bronze).

![image](https://user-images.githubusercontent.com/57301554/151047271-2cb1ac66-75f5-42af-ae1a-fe66ab7ba0a2.png)
![image](https://user-images.githubusercontent.com/57301554/151047379-a8587c41-59eb-411b-a6a4-85d47652718a.png)

##### Again, Michael Phelps has won the most Medals Since inception of the games in 1896

### 13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
-- means 5 countries with most medals

--Select * From [dbo].[athlete_events]

--Select * From [dbo].[noc_regions]

![image](https://user-images.githubusercontent.com/57301554/151047828-1cf1388f-9e89-4d69-86a2-3e2f2352419c.png)
![image](https://user-images.githubusercontent.com/57301554/151047887-a73c27be-8325-4953-8e31-09f7a7961890.png)

### 14. List down total gold, silver and bronze medals won by each country and the total medals each country has won.

![image](https://user-images.githubusercontent.com/57301554/151048133-5c11fcc2-ea9e-45ab-980b-4df02026dc0b.png)
![image](https://user-images.githubusercontent.com/57301554/151048200-a9e7e238-7126-42af-b0e8-d60b08730c71.png)

##### Listed only top 9 countries out of 205. USA has won the most medals in each medal category and most total medals.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
-- need medals ( gold, silver, bronze)

-- need country from regions

-- need games

![image](https://user-images.githubusercontent.com/57301554/151048957-d77ba098-8dd7-4808-9ae4-cc685f20db13.png)
![image](https://user-images.githubusercontent.com/57301554/151049405-919b31c8-dd36-47f0-b176-957cd0cd7ad9.png)

##### Listed a sample data showing 1896 and part of 1900 games

### 16.  Identify which country won the most gold, most silver and most bronze medals in each olympic games.
--need country

--need medals(gold,silver,bronze)

--need games

  ###### These two queries will give me the desired outcome. I used CASE statement to PIVOT the medal rows so I can have each on its column
  ###### Using Window function FIRST_VALUE, I am able to find the top country in each category grouped by games.
  ###### By concatenating the country First_value and Medal count First_value, I am able to get both first values i.e country and total medals

![image](https://user-images.githubusercontent.com/57301554/151224975-10f83c06-8e48-426e-bc76-1ddca36a7a19.png)

![image](https://user-images.githubusercontent.com/57301554/151224496-ef55b4a2-c0b8-4bf6-a923-015f2dc82a1c.png)
![image](https://user-images.githubusercontent.com/57301554/151226240-ae2564b7-dcd0-4a4a-b31b-040a1a0d70e3.png)

##### The results show each game and the country that won the highest number of medals in each category (Gold, Silver, Bronze)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




