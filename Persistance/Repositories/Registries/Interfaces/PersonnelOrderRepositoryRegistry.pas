unit PersonnelOrderRepositoryRegistry;

interface

uses

  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderEmployeeList,
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
    
  end;
  
implementation

end.
