/*

Cleaning Data in SQL Queries

Software Used: Microsoft SQl Server Management Studio

*/

select *
from portfolio_project..nashville_housing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select saledateconverted--, convert(Date, SaleDate)
from portfolio_project..nashville_housing

alter table nashville_housing
add saledateconverted date;

update nashville_housing
set saledateconverted = convert(date, SaleDate)

select *
from portfolio_project..nashville_housing
 

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


select *--propertyaddress
from portfolio_project..nashville_housing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from portfolio_project..nashville_housing a
join portfolio_project..nashville_housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from portfolio_project..nashville_housing a
join portfolio_project..nashville_housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select *
from portfolio_project..nashville_housing


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


select propertyaddress
from portfolio_project..nashville_housing

select 
	SUBSTRING( propertyaddress,1,CHARINDEX(',',propertyaddress) - 1) as address,
	SUBSTRING( propertyaddress,CHARINDEX(',',propertyaddress) + 1, len(propertyaddress)) as address
from portfolio_project..nashville_housing

ALTER TABLE nashville_housing
add propertysplitaddress Nvarchar(255)

ALTER TABLE nashville_housing
add propertysplitcity Nvarchar(255)

update nashville_housing
set propertysplitaddress = SUBSTRING( propertyaddress,1,CHARINDEX(',',propertyaddress) - 1)

update nashville_housing
set propertysplitcity = SUBSTRING( propertyaddress,CHARINDEX(',',propertyaddress) + 1, len(propertyaddress))

select *
from portfolio_project..nashville_housing

select owneraddress
from portfolio_project..nashville_housing

select
PARSENAME(replace(owneraddress,',','.'), 3),
PARSENAME(replace(owneraddress,',','.'), 2),
PARSENAME(replace(owneraddress,',','.'), 1)
from portfolio_project..nashville_housing

ALTER TABLE nashville_housing
add ownersplitaddress Nvarchar(255)

ALTER TABLE nashville_housing
add ownersplitcity Nvarchar(255)

ALTER TABLE nashville_housing
add ownersplitstate Nvarchar(255)

update nashville_housing
set ownersplitaddress = PARSENAME(replace(owneraddress,',','.'), 3)

update nashville_housing
set ownersplitcity = PARSENAME(replace(owneraddress,',','.'), 2)

update nashville_housing
set ownersplitstate = PARSENAME(replace(owneraddress,',','.'), 1)

select * 
from portfolio_project..nashville_housing


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


select distinct(soldasvacant), count(soldasvacant)
from portfolio_project..nashville_housing
group by SoldAsVacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else SoldAsVacant
end
from portfolio_project..nashville_housing

update nashville_housing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
						when soldasvacant = 'N' then 'No'
						else SoldAsVacant
					end
					from nashville_housing

select soldasvacant 
from portfolio_project..nashville_housing


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


select * 
from portfolio_project..nashville_housing

select *,
	ROW_NUMBER() over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num
from portfolio_project..nashville_housing

with rownumcte as (
select *,
	ROW_NUMBER() over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num
from portfolio_project..nashville_housing
)

delete 
from rownumcte
where row_num >1
--order by propertyaddress

select * 
from portfolio_project..nashville_housing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


select *
from portfolio_project..nashville_housing

alter table nashville_housing
drop column propertyaddress, saledate, owneraddress, taxdistrict

select *
from portfolio_project..nashville_housing


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

















