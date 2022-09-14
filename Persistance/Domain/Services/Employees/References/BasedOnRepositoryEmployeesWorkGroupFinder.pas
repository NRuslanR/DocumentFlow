unit BasedOnRepositoryEmployeesWorkGroupFinder;

interface

uses

  EmployeesWorkGroupFinder,
  EmployeesWorkGroup,
  EmployeesWorkGroupRepository,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryEmployeesWorkGroupFinder =
    class (TInterfacedObject, IEmployeesWorkGroupFinder)

      private

        FEmployeesWorkGroupRepository: IEmployeesWorkGroupRepository;

      public

        constructor Create(
          EmployeesWorkGroupRepository: IEmployeesWorkGroupRepository
        );

        function FindEmployeesWorkGroup(const Identity: Variant): TEmployeesWorkGroup;
        function FindEmployeesWorkGroups(const Identities: TVariantList): TEmployeesWorkGroups;

    end;
  
implementation

{ TBasedOnRepositoryEmployeesWorkGroupFinder }

constructor TBasedOnRepositoryEmployeesWorkGroupFinder.Create(
  EmployeesWorkGroupRepository: IEmployeesWorkGroupRepository);
begin

  inherited Create;

  FEmployeesWorkGroupRepository := EmployeesWorkGroupRepository;
  
end;

function TBasedOnRepositoryEmployeesWorkGroupFinder.FindEmployeesWorkGroup(
  const Identity: Variant): TEmployeesWorkGroup;
begin

  Result :=
    FEmployeesWorkGroupRepository.FindEmployeesWorkGroupByIdentity(
      Identity
    );
    
end;

function TBasedOnRepositoryEmployeesWorkGroupFinder.FindEmployeesWorkGroups(
  const Identities: TVariantList): TEmployeesWorkGroups;
begin

  Result :=
    FEmployeesWorkGroupRepository.FindEmployeesWorkGroupsByIdentities(
      Identities
    );
    
end;

end.
