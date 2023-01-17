
select * from school.dbo.[portfolio project]
--Standardize date format

alter table [portfolio project]
add SaleDateConverted Date;
update [portfolio project]
set SaleDateconverted = CAST(SaleDate as date)

--populate property address data
select PropertyAddress from school.dbo.[portfolio project]
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress
from school.dbo.[portfolio project] as a
join school.dbo.[portfolio project] as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null
update a
set a.PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from school.dbo.[portfolio project] as a
join school.dbo.[portfolio project] as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]

-- Breaking out address into individual columns(address, city, state)

select SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress) -1) from school.dbo.[portfolio project]
              
Alter table school.dbo.[portfolio project]
add Propertynewaddress nvarchar(255);

update school.dbo.[portfolio project]
set Propertynewaddress = SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress) -1) 

update school.dbo.[portfolio project]
set Propertyaddresscity = SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1 , len(Propertyaddress)) 


Select PARSENAME(replace(OwnerAddress,',','.'), 3) from school.dbo.[portfolio project]

Alter table school.dbo.[portfolio project]
add Ownersnewaddress nvarchar(255);

update school.dbo.[portfolio project]
set Ownersnewaddress =  PARSENAME(replace(OwnerAddress,',','.'), 3)
Alter table school.dbo.[portfolio project]
add Ownerscity nvarchar(255);

update school.dbo.[portfolio project]
set Ownerscity = PARSENAME(replace(OwnerAddress,',','.'), 2) 

Alter table school.dbo.[portfolio project]
add Ownersstate nvarchar(255);

update school.dbo.[portfolio project]
set Ownersstate = PARSENAME(replace(OwnerAddress,',','.'), 1) 

Select * from school.dbo.[portfolio project]


-- updatig 'y' as yes and 'N' as No in soldasvacant

Select distinct(SoldAsVacant), COUNT(SoldAsVacant) from school.dbo.[portfolio project]
group by SoldAsVacant
order by 2

update school.dbo.[portfolio project]
set SoldAsVacant = case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

-- removing duplicates


select * from school.dbo.[portfolio project]
with rownumcte as(
select *, ROW_NUMber() over ( 
partition by
            ParcelID, 
			PropertyAddress,
			SaleDate,
			LegalReference
			order by UniqueID) row_num

			from school.dbo.[portfolio project]
)