--standardized date format

alter table NashvilleHousing
Add SaleConverted Date

update NashvilleHousing
set SaleConverted = convert(date, [Sale Date])


select *
from NashvilleHousing

--POPULATE PROPERTY ADDRESS
select a.[Parcel ID], a.[Property Address], b.[Parcel ID], b.[Property Address], ISNULL(a.[Property Address], b.[Property Address])
from NashvilleHousing a
join NashvilleHousing b
on a.[Parcel ID] = b.[Parcel ID]
and a.F1 <> b.F1
where a.[Property Address] is null

update a
set [Property Address] = ISNULL(a.[Property Address], b.[Property Address])
from NashvilleHousing a
join NashvilleHousing b
on a.[Parcel ID] = b.[Parcel ID]
and a.F1 <> b.F1
where a.[Property Address] is null

update c
set [Property Address] = ISNULL(d.[Property Address], 'No address')
from NashvilleHousing c
join NashvilleHousing d
on c.[Parcel ID] = d.[Parcel ID]
and c.F1 <> d.F1



--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (Address, City, State)
--My dataset has already been splitted

-- Change Y and N to Yes and No in 'Sold as Vacant' field
select distinct([Sold As Vacant]),
CASE When [Sold As Vacant] = 'Y' then 'Yes'
		when [Sold As Vacant] = 'N' then 'No'
		else [Sold As Vacant]
		end
from NashvilleHousing

update NashvilleHousing
set [Sold As Vacant] = CASE When [Sold As Vacant] = 'Y' then 'Yes'
		when [Sold As Vacant] = 'N' then 'No'
		else [Sold As Vacant]
		end



--remove duplicate
WITH RowNumCTE as (
select *, ROW_NUMBER() over (partition by F1, [Sale Date], [Sale Price], [Legal Reference] order by F1) as Row_Number
from NashvilleHousing

)

select *
from RowNumCTE
where Row_Number > 1

-- delete unsused column
alter table PortfolioProject.dbo.NashvilleHousing
drop column [Unnamed: 0], [Sale Date], [Tax District]

select *
from PortfolioProject.dbo.NashvilleHousing
