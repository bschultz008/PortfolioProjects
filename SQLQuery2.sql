/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------

--------STANDERIZE DATA FORMAT--------

select SaleDate, CONVERT(Date,SaleDate)    ----1.Essentially you are declaring two rows, the first one as the orginal row and the following row you are declaring as a function
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)---1.You are copying the row that you declared as a function and setting the data eqal to the SaleData column------BUT IT WONT WORK

--------above is the first version that had issues running through the system but dont negate this way of doing it

ALTER TABLE NashvilleHousing -----2. this is an alternative way to copy data from a declared function column to an orginal column; In this example you are just adding a new column
ADD SaleDateConverted Date

UPDATE NashvilleHousing --------2. Now you are setting the added column the functioned column
SET SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted, CONVERT(Date,SaleDate) --------2.You are now selecting both rows to see if they are identical to one another  
from PortfolioProject.dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------------------------------------------------------------

-----POPULATE PROPERTY ADDRESS DATA

/* The objective of this was to first locate null values, Once he did this he was finding a connection between the column that 
has null values and other columns to make it easier to fill in the data. If you explore a table and notice that multiple rows always
have 1 or more column that are have the exact same information in it, you can use this as a guide to fill in columns that have that missing
information becuase you know its supposed to be there. For this example you are going to use self join, basically joining the same table
together to force it to fill in information on 1 or more constrain or functions that you have defined. If a*/

select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null  
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
      /*Since you are joinin the table to itself you are going to use 4 columns because you have 2 columns in the table that are
	  connected to each other but you are going to use those twice which makes 4 in order match the columns at the parcel_id column but also
	  be able to use a where clause for the Property Address to find the nulls and match them for another column*/
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ]<>b.[UniqueID ]
	 /* The Join Statement above can be explained like this: NH a is joined to NH b on the columns of The Identical Parcel_id but different Unique_ids.
	 The reason for Identical Parcel_id is becuase the Parcel_id can be looked at as a key or guide to help us fill in the Null Values for the duplicate
	 table we are making for ourself. Logically we the unique_id does not have a strong coorelation to help us identify the missing value becuase The unique_id and 
	 Property address are not conncted ubiqioutsley everywhere in the whole table but on the other hand the Parcel_id is connected to the proprety address in a way 
	 to help us find the answer. We do need the unique_id to help us summon all the rows in table that potentailly need fixing, so the Unique_id is there to give us 
	 all the rows and parcell_id is there to fix the rows.*/
Where a.PropertyAddress is null
	/* The where is clause is here to narrow down the rows that are summoned to help us only find the rows that need fixing.*/
	


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ]<>b.[UniqueID ]


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----BREAKING OUT ADDRESS INTO INDVIDUAL COLUMNS (ADDRESS,CITY,STATE)


select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null  
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as city
/*The query above is a substring query which is basically manipulating strings inside of the rows. The first line is picking the column you want to be in and also selecting the positon 
you want, next you are pickin where you want to substring to end at, you can do this by selecting charindex within the substring function. -1 means to go before the charindex and +1 means to
go after the charindex*/


FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing -----2. this is an alternative way to copy data from a declared function column to an orginal column; In this example you are just adding a new column
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing --------2. Now you are setting the added column the functioned column
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE NashvilleHousing -----2. this is an alternative way to copy data from a declared function column to an orginal column; In this example you are just adding a new column
ADD PropertySplitCityDate nvarchar(255)

UPDATE NashvilleHousing --------2. Now you are setting the added column the functioned column
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 
/*We use the Alter table  and Update functions to create a new column and then add the values to them. When updating the tables you can set the new 
columns to the function you have created to get your new values.*/




select 
PARSENAME(OwnerAddress,1)
from PortfolioProject..NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
from PortfolioProject..NashvilleHousing
/* Parsename is the easier way break out strings into individaul columns. The only difference is that 
parsename only recognized the period as a delimeter so you will have to use the replace function witin the 
parsename function and replace the period with whatever delimeter you have, also when you are declaring a position 
and have more than 1 position the declaration is backwards so you will have to put the number backwards.*/

ALTER TABLE NashvilleHousing -----2. this is an alternative way to copy data from a declared function column to an orginal column; In this example you are just adding a new column
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing --------2. Now you are setting the added column the functioned column
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),

ALTER TABLE NashvilleHousing -----2. this is an alternative way to copy data from a declared function column to an orginal column; In this example you are just adding a new column
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing --------2. Now you are setting the added column the functioned column
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
/*We use the Alter table  and Update functions to create a new column and then add the values to them. When updating the tables you can set the new 
columns to the function you have created to get your new values.*/

ALTER TABLE NashvilleHousing -----2. this is an alternative way to copy data from a declared function column to an orginal column; In this example you are just adding a new column
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing --------2. Now you are setting the added column the functioned column
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
/*We use the Alter table  and Update functions to create a new column and then add the values to them. When updating the tables you can set the new 
columns to the function you have created to get your new values.*/



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD


select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2
/*The query above we are selecting only distinct values to basically see one of over different value, we are also selecting the count of those distinct values
and since count is an aggregate function we have to add this clause in the group by function.*/



Select SoldAsVacant,
	Case when SoldAsVacant = 'Y' THEN 'Yes'
	     When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant END 
from PortfolioProject..NashvilleHousing
/*Now we are formulating a case statement, this statement is basically saying whenever there is value a the put value b, additionally
if there is a value x put value y, if there isnt leave it as is.*/

Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = 
	Case when SoldAsVacant = 'Y' THEN 'Yes'
	     When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant END 
/*basically we can look at the case query as a function that we can make equal to the "update"- "set" clause.*/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----REMOVE DUPLICATES



WITH RowNumCTE AS (
Select *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)

Select *
From RowNumCTE
where row_num > 1
order by PropertyAddress

/*The query above is selecting the created CTE table to unveil duplicates that were marked by the rows as rank rows.*/

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)

DELETE 
From RowNumCTE
where row_num > 1
--Order by PropertyAddress
/* The query above is deleting the rows that we have unveieled as duplicated from the temp table*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DELETE UNUSED COLUMNS

select *
from PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate

/*Here we are dropping rows that we dont need by usin the Alter table drop column function.*/
					
					
				



