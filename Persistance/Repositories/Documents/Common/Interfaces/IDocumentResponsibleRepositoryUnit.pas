unit IDocumentResponsibleRepositoryUnit;

interface

uses

  SysUtils,
  Classes,
  DomainObjectUnit,
  Employee,
  DepartmentUnit;

type

  TDocumentResponsible = class (TDomainObject)

  end;
  
  IDocumentResponsibleRepository = interface

    function FindDocumentResponsibleById(
      const ResponsibleId: Variant
    ): TEmployee;

    function FindDocumentResponsibleDepartmentById(
      const DepartmentId: Variant
    ): TDepartment;

    procedure UpdateDocumentResponsible(DocumentResponsible: TEmployee);
    
  end;

implementation

end.
