-- cleaning data in SQL

select *
from dbo.NationalHousing

-- standized date format
select SaleDateConverted, convert(date,saledate)
from dbo.NationalHousing

update NationalHousing
set SaleDate = convert(date,saledate)

alter table nationalhousing
add SaleDateConverted date

update NationalHousing
set SaleDateConverted = convert(date,saledate)

-- populate property address data
select *
from dbo.NationalHousing
-- where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
	isnull(a.PropertyAddress, b.PropertyAddress)
from dbo.NationalHousing a
	JOIN dbo.NationalHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from dbo.NationalHousing a
	JOIN dbo.NationalHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

-- breaking out address into individual  colums (address, city, state)
select PropertyAddress
from dbo.NationalHousing

select
substring(propertyaddress, 1, CHARINDEX(',',propertyaddress) -1) as address
,substring(propertyaddress, CHARINDEX(',',propertyaddress) +1, len(propertyaddress)) as address
from dbo.NationalHousing

alter table nationalhousing
add addresssplit Nvarchar(255);
update NationalHousing
set addresssplit = substring(propertyaddress, 1, CHARINDEX(',',propertyaddress) -1)

alter table nationalhousing
add addresssplitcity Nvarchar(255);
update NationalHousing
set addresssplitcity = substring(propertyaddress, CHARINDEX(',',propertyaddress) +1, len(propertyaddress))
alter table nationalhousing
drop column addresssplitcity;

select OwnerAddress
from dbo.NationalHousing

select
parsename(replace(OwnerAddress, ',', '.'),1),
parsename(replace(OwnerAddress, ',', '.'),2),
parsename(replace(OwnerAddress, ',', '.'),3)
from dbo.NationalHousing

select distinct(SoldAsVacant), count(soldasvacant)
from dbo.NationalHousing
group by SoldAsVacant
order by 2

alter table nationalhousing
alter column soldasvacant Nvarchar(255);
select*
from dbo.NationalHousing
select soldasvacant
, case when SoldAsVacant = '0' then 'No'
		when SoldAsVacant = '1' then 'Yes'
		else SoldAsVacant
		end
from dbo.NationalHousing

update NationalHousing
set SoldAsVacant = case 
when SoldAsVacant= '0' then 'No'
when SoldAsVacant = '1' then 'Yes'
else SoldAsVacant
end

-- remove duplicates

with rowNumCTE as (
select *,
	row_number() over (
	partition by parcelID,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
					uniqueID
					) row_num
from NationalHousing
-- order by parcelID
)
select *
from rowNumCTE
WHERE row_num>1
-- order by propertyAddress


-- delete unused columns

select *
from NationalHousing

alter table nationalhousing
drop column taxdistrict

alter table nationalhousing
drop column saledate