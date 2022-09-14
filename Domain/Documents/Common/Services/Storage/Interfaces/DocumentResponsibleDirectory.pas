unit DocumentResponsibleDirectory;

interface

uses

  Employee,
  DepartmentUnit;
  
type

  IDocumentResponsibleDirectory = interface

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

end.
