unit PersonnelOrderRepositoryRegistry;

interface

uses

  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderEmployeeList,
  PersonnelOrderSubKindRepository,
  PersonnelOrderSubKindEmployeeList,
  PersonnelOrderSubKindEmployeeGroup;

type

  IPersonnelOrderRepositoryRegistry = interface

    procedure RegisterPersonnelOrderSignerListRepository(
      PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository
    );

    function GetPersonnelOrderSignerListRepository: IPersonnelOrderSingleEmployeeListRepository;


    procedure RegisterPersonnelOrderApproverListRepository(
      PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
    );

    function GetPersonnelOrderApproverListRepository: IPersonnelOrderSubKindEmployeeListRepository;


    procedure RegisterPersonnelOrderControlGroupRepository(
      PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository
      );

    function GetPersonnelOrderControlGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository;


    procedure RegisterPersonnelOrderCreatingAccessEmployeeRepository(
      PersonnelOrderCreatingAccessEmployeeRepository: IPersonnelOrderSingleEmployeeListRepository
    );

    function GetPersonnelOrderCreatingAccessEmployeeRepository: IPersonnelOrderSingleEmployeeListRepository;

    procedure RegisterPersonnelOrderSubKindRepository(
      PersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository
    );

    function GetPersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository;

  end;
  
implementation

end.
