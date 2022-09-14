unit BasedOnRepositoryDocumentResponsibleDirectory;

interface

uses

  DocumentResponsibleDirectory,
  IDocumentResponsibleRepositoryUnit,
  Employee,
  DepartmentUnit,
  SysUtils;

type

  TBasedOnRepositoryDocumentResponsibleDirectory =
    class (TInterfacedObject, IDocumentResponsibleDirectory)

      protected

        FDocumentResponsibleRepository: IDocumentResponsibleRepository;
        
      public

        constructor Create(DocumentResponsibleRepository: IDocumentResponsibleRepository);
        
        function FindDocumentResponsibleById(
          const ResponsibleId: Variant
        ): TEmployee;

        function FindDocumentResponsibleDepartmentById(
          const DepartmentId: Variant
        ): TDepartment;

        procedure UpdateDocumentResponsibleTelephoneNumber(
          const ResponsibleId: Variant;
          const NewTelephoneNumber: String
        );
      
    end;


implementation

{ TBasedOnRepositoryDocumentResponsibleDirectory }

constructor TBasedOnRepositoryDocumentResponsibleDirectory.Create(
  DocumentResponsibleRepository: IDocumentResponsibleRepository);
begin

  inherited Create;

  FDocumentResponsibleRepository := DocumentResponsibleRepository;

end;

function TBasedOnRepositoryDocumentResponsibleDirectory.FindDocumentResponsibleById(
  const ResponsibleId: Variant): TEmployee;
begin

  Result := FDocumentResponsibleRepository.FindDocumentResponsibleById(ResponsibleId);
  
end;

function TBasedOnRepositoryDocumentResponsibleDirectory.FindDocumentResponsibleDepartmentById(
  const DepartmentId: Variant
): TDepartment;
begin

  Result := FDocumentResponsibleRepository.FindDocumentResponsibleDepartmentById(DepartmentId);

end;

procedure TBasedOnRepositoryDocumentResponsibleDirectory.
  UpdateDocumentResponsibleTelephoneNumber(
    const ResponsibleId: Variant;
    const NewTelephoneNumber: String
  );
var DocumentResponsible: TEmployee;
begin

  DocumentResponsible :=
    FDocumentResponsibleRepository.FindDocumentResponsibleById(ResponsibleId);

  DocumentResponsible.TelephoneNumber := NewTelephoneNumber;

  FDocumentResponsibleRepository.UpdateDocumentResponsible(DocumentResponsible);

end;

end.
