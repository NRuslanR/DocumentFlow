unit RepositoryList;

interface

uses

  TypeObjectRegistry,
  DomainObjectBaseUnit,
  SysUtils,
  Classes;
  
type

  TRepositories = class

    private

      FInternalRegistry: TTypeObjectRegistry;

    private

      function GetRepositoryByDomainObjectClass(
        DomainObjectClass: TDomainObjectBaseClass
      ): IInterface;

      procedure SetRepositoryByDomainObjectClass(
        DomainObjectClass: TDomainObjectBaseClass;
        Repository: IInterface
      );

    public

      destructor Destroy; override;
      constructor Create;

      procedure AddOrUpdateRepository(
        DomainObjectClass: TDomainObjectBaseClass;
        Repository: IInterface
      );
     
      property Items[DomainObjectClass: TDomainObjectBaseClass]: IInterface
      read GetRepositoryByDomainObjectClass
      write SetRepositoryByDomainObjectClass; default;
            
    end;
        
implementation

{ TRepositories }

procedure TRepositories.AddOrUpdateRepository(
  DomainObjectClass: TDomainObjectBaseClass; Repository: IInterface);
begin

  FInternalRegistry.RegisterInterface(
    DomainObjectClass, Repository
  );
  
end;

constructor TRepositories.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FInternalRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TRepositories.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TRepositories.GetRepositoryByDomainObjectClass(
  DomainObjectClass: TDomainObjectBaseClass): IInterface;
begin

  Result := FInternalRegistry.GetInterface(DomainObjectClass);
                    
end;

procedure TRepositories.SetRepositoryByDomainObjectClass(
  DomainObjectClass: TDomainObjectBaseClass; Repository: IInterface);
begin

   FInternalRegistry.RegisterInterface(DomainObjectClass, Repository);
   
end;

end.
