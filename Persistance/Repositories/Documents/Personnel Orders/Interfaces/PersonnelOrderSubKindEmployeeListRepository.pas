unit PersonnelOrderSubKindEmployeeListRepository;

interface

uses

  PersonnelOrderSubKindEmployeeList,
  PersonnelOrderEmployeeListRepository,
  SysUtils;

type

  IPersonnelOrderSubKindEmployeeListRepository =
    interface (IPersonnelOrderEmployeeListRepository)

      function FindPersonnelOrderSubKindEmployeeListBySubKind(
        const PersonnelOrderSubKindId: Variant
      ): TPersonnelOrderSubKindEmployeeList;

      function FindAllPersonnelOrderSubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists;

      procedure AddPersonnelOrderSubKindEmployeeList(
        SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
      );

      procedure AddPersonnelOrderSubKindEmployeeLists(
        SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists
      );

      procedure UpdatePersonnelOrderSubKindEmployeeList(
        SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
      );

      procedure UpdatePersonnelOrderSubKindEmployeeLists(
        SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists
      );

      procedure RemovePersonnelOrderSubKindEmployeeList(
        SubKindEmployeeList: TPersonnelOrderSubKindEmployeeList
      );

      procedure RemovePersonnelOrderSubKindEmployeeLists(
        SubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists
      );
      
    end;
  
implementation

end.
