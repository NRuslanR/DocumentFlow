program Persistance;

uses
  Forms,
  BasedOnRepositoryApprovingCycleResultFinder in 'Domain\Services\Documents\Approving\BasedOnRepositoryApprovingCycleResultFinder.pas',
  BasedOnRepositoryDocumentChargeSheetFinder in 'Domain\Services\Documents\Charge Sheets\BasedOnRepositoryDocumentChargeSheetFinder.pas',
  BasedOnRepositoryDocumentResponsibleFinder in 'Domain\Services\Documents\Formalization\BasedOnRepositoryDocumentResponsibleFinder.pas',
  BasedOnRepositoryEmployeeFinder in 'Domain\Services\Employees\References\BasedOnRepositoryEmployeeFinder.pas',
  DocumentApprovingCycleResultRepository in 'Repositories\Documents\Common\Interfaces\DocumentApprovingCycleResultRepository.pas',
  DocumentChargeSheetRepository in 'Repositories\Documents\Common\Interfaces\DocumentChargeSheetRepository.pas',
  DocumentFilesRepository in 'Repositories\Documents\Common\Interfaces\DocumentFilesRepository.pas',
  DocumentRelationsRepository in 'Repositories\Documents\Common\Interfaces\DocumentRelationsRepository.pas',
  DocumentRepository in 'Repositories\Documents\Common\Interfaces\DocumentRepository.pas',
  IDocumentResponsibleRepositoryUnit in 'Repositories\Documents\Common\Interfaces\IDocumentResponsibleRepositoryUnit.pas',
  IncomingDocumentRepository in 'Repositories\Documents\Common\Interfaces\IncomingDocumentRepository.pas',
  DepartmentRepository in 'Repositories\Employees\Interfaces\DepartmentRepository.pas',
  IEmployeeRepositoryUnit in 'Repositories\Employees\Interfaces\IEmployeeRepositoryUnit.pas',
  IRoleRepositoryUnit in 'Repositories\Employees\Interfaces\IRoleRepositoryUnit.pas',
  RepositoryRegistryUnit in 'Repositories\Registries\RepositoryRegistryUnit.pas',
  IRepositoryRegistryUnit in 'Repositories\Registries\Interfaces\IRepositoryRegistryUnit.pas',
  BasedOnRepositoryDepartmentFinder in 'Domain\Services\Employees\References\BasedOnRepositoryDepartmentFinder.pas',
  EmployeesWorkGroupRepository in 'Repositories\Employees\Interfaces\EmployeesWorkGroupRepository.pas',
  BasedOnRepositoryEmployeesWorkGroupFinder in 'Domain\Services\Employees\References\BasedOnRepositoryEmployeesWorkGroupFinder.pas',
  DocumentKindRepository in 'Repositories\Documents\Common\Interfaces\DocumentKindRepository.pas',
  DocumentRepositoryRegistry in 'Repositories\Registries\Interfaces\DocumentRepositoryRegistry.pas',
  RepositoryList in 'Repositories\Registries\RepositoryList.pas',
  StandardDocumentRepositoryRegistry in 'Repositories\Registries\StandardDocumentRepositoryRegistry.pas',
  BasedOnRepositoryDocumentRelationsFinder in 'Domain\Services\Documents\Relations\BasedOnRepositoryDocumentRelationsFinder.pas',
  BasedOnPostgresDocumentNumeratorRegistry in 'Domain\Services\Documents\Numerators\BasedOnPostgresDocumentNumeratorRegistry.pas',
  BasedOnRepositoryDocumentApprovingFinder in 'Domain\Services\Documents\Approving\BasedOnRepositoryDocumentApprovingFinder.pas',
  DocumentApprovingRepository in 'Repositories\Documents\Common\Interfaces\DocumentApprovingRepository.pas',
  BasedOnRepositoryDocumentFinder in 'Domain\Services\Documents\Search\BasedOnRepositoryDocumentFinder.pas',
  BasedOnRepositoryDocumentDirectory in 'Domain\Services\Documents\Storage\BasedOnRepositoryDocumentDirectory.pas',
  BasedOnRepositoryDocumentFileMetadataDirectory in 'Domain\Services\Documents\Storage\BasedOnRepositoryDocumentFileMetadataDirectory.pas',
  BasedOnRepositoryDocumentRelationDirectory in 'Domain\Services\Documents\Storage\BasedOnRepositoryDocumentRelationDirectory.pas',
  BasedOnRepositoryDocumentResponsibleDirectory in 'Domain\Services\Documents\Storage\BasedOnRepositoryDocumentResponsibleDirectory.pas',
  BasedOnRepositoryDocumentApprovingCycleResultDirectory in 'Domain\Services\Documents\Storage\BasedOnRepositoryDocumentApprovingCycleResultDirectory.pas',
  BasedOnRepositoryIncomingDocumentDirectory in 'Domain\Services\Documents\Storage\BasedOnRepositoryIncomingDocumentDirectory.pas',
  BasedOnRepositoryDocumentChargeSheetDirectory in 'Domain\Services\Documents\Charge Sheets\BasedOnRepositoryDocumentChargeSheetDirectory.pas',
  BasedOnDatabaseDocumentNumeratorRegistry in 'Domain\Services\Documents\Numerators\BasedOnDatabaseDocumentNumeratorRegistry.pas',
  BaseDocumentPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\BaseDocumentPostgresRepository.pas',
  DocumentApprovingCycleResultPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentApprovingCycleResultPostgresRepository.pas',
  DocumentApprovingPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentApprovingPostgresRepository.pas',
  DocumentChargePostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentChargePostgresRepository.pas',
  DocumentChargeSheetPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentChargeSheetPostgresRepository.pas',
  DocumentFilesPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentFilesPostgresRepository.pas',
  DocumentKindPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentKindPostgresRepository.pas',
  DocumentPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentPostgresRepository.pas',
  DocumentRelationsPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentRelationsPostgresRepository.pas',
  DocumentResponsiblePostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentResponsiblePostgresRepository.pas',
  DocumentSigningPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentSigningPostgresRepository.pas',
  HistoricalDocumentApprovingPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\HistoricalDocumentApprovingPostgresRepository.pas',
  IncomingDocumentPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\IncomingDocumentPostgresRepository.pas',
  IncomingServiceNoteTable in 'Schema\Documents\Service Notes\IncomingServiceNoteTable.pas',
  LookedServiceNotesPostgresTable in 'Schema\Documents\Service Notes\LookedServiceNotesPostgresTable.pas',
  ServiceNoteApprovingsTable in 'Schema\Documents\Service Notes\ServiceNoteApprovingsTable.pas',
  ServiceNoteChargeSheetTable in 'Schema\Documents\Service Notes\ServiceNoteChargeSheetTable.pas',
  ServiceNoteDBTableUnit in 'Schema\Documents\Service Notes\ServiceNoteDBTableUnit.pas',
  ServiceNoteFilesDBTableUnit in 'Schema\Documents\Service Notes\ServiceNoteFilesDBTableUnit.pas',
  ServiceNoteLinksDBTableUnit in 'Schema\Documents\Service Notes\ServiceNoteLinksDBTableUnit.pas',
  ServiceNoteReceiversDBTable in 'Schema\Documents\Service Notes\ServiceNoteReceiversDBTable.pas',
  ServiceNoteSigningTable in 'Schema\Documents\Service Notes\ServiceNoteSigningTable.pas',
  ServiceNoteTable in 'Schema\Documents\Service Notes\ServiceNoteTable.pas',
  SelectDocumentRecordsViewQueries in 'Queries\Documents\Postgres\SelectDocumentRecordsViewQueries.pas',
  EmployeePostgresRepositoryQueryTextsUnit in 'Queries\Employees\Postgres\EmployeePostgresRepositoryQueryTextsUnit.pas',
  EmployeeReplacementQueryTexts in 'Queries\Employees\Postgres\EmployeeReplacementQueryTexts.pas',
  EmployeesViewQueryTextsUnit in 'Queries\Employees\Postgres\EmployeesViewQueryTextsUnit.pas',
  DepartmentPostgresRepository in 'Repositories\Employees\SQL\Postgres\DepartmentPostgresRepository.pas',
  EmployeePostgresRepository in 'Repositories\Employees\SQL\Postgres\EmployeePostgresRepository.pas',
  EmployeeReplacementPostgresRepository in 'Repositories\Employees\SQL\Postgres\EmployeeReplacementPostgresRepository.pas',
  EmployeesWorkGroupPostgresRepository in 'Repositories\Employees\SQL\Postgres\EmployeesWorkGroupPostgresRepository.pas',
  RolePostgresRepository in 'Repositories\Employees\SQL\Postgres\RolePostgresRepository.pas',
  PersonnelOrderPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderPostgresRepository.pas',
  DocumentWorkCycleStagesPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentWorkCycleStagesPostgresRepository.pas',
  DocumentWorkCycleRepository in 'Repositories\Documents\Common\Interfaces\DocumentWorkCycleRepository.pas',
  DocumentWorkCycleStagesRepository in 'Repositories\Documents\Common\Interfaces\DocumentWorkCycleStagesRepository.pas',
  StandardDocumentWorkCycleRepository in 'Repositories\Documents\Common\Standard\StandardDocumentWorkCycleRepository.pas',
  BasedOnRepositoryDocumentWorkCycleFinder in 'Domain\Services\Documents\Search\BasedOnRepositoryDocumentWorkCycleFinder.pas',
  DocumentApprovingsTableDef in 'Schema\Documents\Common\DocumentApprovingsTableDef.pas',
  DocumentChargeSheetTableDef in 'Schema\Documents\Common\DocumentChargeSheetTableDef.pas',
  DocumentChargeTableDef in 'Schema\Documents\Common\DocumentChargeTableDef.pas',
  DocumentFilesTableDef in 'Schema\Documents\Common\DocumentFilesTableDef.pas',
  DocumentNumeratorTableDef in 'Schema\Documents\Common\DocumentNumeratorTableDef.pas',
  DocumentRelationsTableDef in 'Schema\Documents\Common\DocumentRelationsTableDef.pas',
  DocumentSigningTableDef in 'Schema\Documents\Common\DocumentSigningTableDef.pas',
  DocumentsViewDef in 'Schema\Documents\Common\DocumentsViewDef.pas',
  DocumentTableDef in 'Schema\Documents\Common\DocumentTableDef.pas',
  DocumentTypesTableDef in 'Schema\Documents\Common\DocumentTypesTableDef.pas',
  DocumentTypeStageTableDef in 'Schema\Documents\Common\DocumentTypeStageTableDef.pas',
  IncomingDocumentTableDef in 'Schema\Documents\Common\IncomingDocumentTableDef.pas',
  DocumentTableDefsFactory in 'Schema\Documents\Factories\DocumentTableDefsFactory.pas',
  TableDef in 'Schema\Common\TableDef.pas',
  DocumentApprovingResultsTableDef in 'Schema\Documents\Common\DocumentApprovingResultsTableDef.pas',
  DepartmentTableDef in 'Schema\Employees\Common\DepartmentTableDef.pas',
  EmployeeContactInfoTableDef in 'Schema\Employees\Common\EmployeeContactInfoTableDef.pas',
  EmployeeRoleAssocTableDef in 'Schema\Employees\Common\EmployeeRoleAssocTableDef.pas',
  EmployeeTableDef in 'Schema\Employees\Common\EmployeeTableDef.pas',
  EmployeeViewDef in 'Schema\Employees\Common\EmployeeViewDef.pas',
  EmployeeWorkGroupAssocTableDef in 'Schema\Employees\Common\EmployeeWorkGroupAssocTableDef.pas',
  EmployeeWorkGroupTableDef in 'Schema\Employees\Common\EmployeeWorkGroupTableDef.pas',
  RoleTableDef in 'Schema\Employees\Common\RoleTableDef.pas',
  DocumentTableDefsFactoryRegistry in 'Schema\Documents\Factories\DocumentTableDefsFactoryRegistry.pas',
  AbstractDocumentRepositoriesFactory in 'Repositories\Documents\Factories\AbstractDocumentRepositoriesFactory.pas',
  PostgresDocumentRepositoriesFactory in 'Repositories\Documents\Factories\PostgresDocumentRepositoriesFactory.pas',
  EmployeeReplacementTableDef in 'Schema\Employees\Common\EmployeeReplacementTableDef.pas',
  ServiceNoteTableDefsFactory in 'Schema\Documents\Factories\ServiceNoteTableDefsFactory.pas',
  AbstractDocumentRepositoriesFactoryRegistry in 'Repositories\Documents\Factories\AbstractDocumentRepositoriesFactoryRegistry.pas',
  PostgresDocumentRepositoriesFactoryRegistry in 'Repositories\Documents\Factories\PostgresDocumentRepositoriesFactoryRegistry.pas',
  DocumentRepositoryRegistryInitializer in 'Repositories\Registries\DocumentRepositoryRegistryInitializer.pas',
  PersonnelOrderSubKindEmployeeGroupPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderSubKindEmployeeGroupPostgresRepository.pas',
  PersonnelOrderSubKindEmployeeGroupRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderSubKindEmployeeGroupRepository.pas',
  PersonnelOrderEmployeeListTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderEmployeeListTableDef.pas',
  PersonnelOrdersTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrdersTableDef.pas',
  PersonnelOrdersViewDef in 'Schema\Documents\Personnel Orders\PersonnelOrdersViewDef.pas',
  PersonnelOrderEmployeeGroupEmployeeAssociationRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderEmployeeGroupEmployeeAssociationRepository.pas',
  PersonnelOrderEmployeeGroupSubKindAssociationRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderEmployeeGroupSubKindAssociationRepository.pas',
  PersonnelOrderEmployeeGroupRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderEmployeeGroupRepository.pas',
  PersonnelOrderEmployeeListRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderEmployeeListRepository.pas',
  PersonnelOrderSubKindEmployeeListRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderSubKindEmployeeListRepository.pas',
  PersonnelOrderEmployeeListPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderEmployeeListPostgresRepository.pas',
  PersonnelOrderSubKindEmployeeListTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderSubKindEmployeeListTableDef.pas',
  PersonnelOrderSubKindEmployeeListPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderSubKindEmployeeListPostgresRepository.pas',
  PersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.pas',
  PersonnelOrderEmployeeGroupEmployeeAssociationTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderEmployeeGroupEmployeeAssociationTableDef.pas',
  PersonnelOrderEmployeeGroupSubKindAssociationTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderEmployeeGroupSubKindAssociationTableDef.pas',
  PersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.pas',
  PersonnelOrderEmployeeGroupPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderEmployeeGroupPostgresRepository.pas',
  PersonnelOrderEmployeeGroupTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderEmployeeGroupTableDef.pas',
  PersonnelOrderSingleEmployeeListRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderSingleEmployeeListRepository.pas',
  PersonnelOrderSingleEmployeeListPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderSingleEmployeeListPostgresRepository.pas',
  BasedOnRepositoryPersonnelOrderEmployeeListFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderEmployeeListFinder.pas',
  BasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder.pas',
  BasedOnRepositoryPersonnelOrderApproverListFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderApproverListFinder.pas',
  BasedOnRepositoryPersonnelOrderSingleEmployeeListFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderSingleEmployeeListFinder.pas',
  BasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder.pas',
  BasedOnRepositoryPersonnelOrderSignerListFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderSignerListFinder.pas',
  BasedOnRepositoryPersonnelOrderEmployeeGroupFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderEmployeeGroupFinder.pas',
  BasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderSubKindEmployeeGroupFinder.pas',
  BasedOnRepositoryPersonnelOrderControlGroupFinder in 'Domain\Services\Documents\Personnel Orders\Search\BasedOnRepositoryPersonnelOrderControlGroupFinder.pas',
  PersonnelOrderSubKindTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderSubKindTableDef.pas',
  PersonnelOrderRepositoryRegistry in 'Repositories\Registries\Interfaces\PersonnelOrderRepositoryRegistry.pas',
  StandardPersonnelOrderRepositoryRegistry in 'Repositories\Registries\StandardPersonnelOrderRepositoryRegistry.pas',
  PersonnelOrderTableDefsFactory in 'Schema\Documents\Factories\PersonnelOrderTableDefsFactory.pas',
  PostgresPersonnelOrderRepositoriesFactory in 'Repositories\Documents\Factories\PostgresPersonnelOrderRepositoriesFactory.pas',
  PersonnelOrderRepositoryRegistryInitializer in 'Repositories\Registries\PersonnelOrderRepositoryRegistryInitializer.pas',
  PersonnelOrderRepositoriesFactory in 'Repositories\Documents\Factories\Interfaces\PersonnelOrderRepositoriesFactory.pas',
  LookedDocumentsTableDef in 'Schema\Documents\Common\LookedDocumentsTableDef.pas',
  PersonnelOrderSignerListPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderSignerListPostgresRepository.pas',
  PersonnelOrderSignerListRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderSignerListRepository.pas',
  PersonnelOrderSignerListTableDef in 'Schema\Documents\Personnel Orders\PersonnelOrderSignerListTableDef.pas',
  DocumentRepositoriesFactory in 'Repositories\Documents\Factories\Interfaces\DocumentRepositoriesFactory.pas',
  DocumentChargeKindTableDef in 'Schema\Documents\Common\DocumentChargeKindTableDef.pas',
  DocumentChargeKindRepository in 'Repositories\Documents\Common\Interfaces\DocumentChargeKindRepository.pas',
  DocumentChargeKindPostgresRepository in 'Repositories\Documents\Common\SQL\Postgres\DocumentChargeKindPostgresRepository.pas',
  BasedOnRepositoryDocumentChargeKindsControlService in 'Domain\Services\Documents\Charges\BasedOnRepositoryDocumentChargeKindsControlService.pas',
  DocumentChargeRepository in 'Repositories\Documents\Common\Interfaces\DocumentChargeRepository.pas',
  BasedOnRepositoryDocumentKindFinder in 'Domain\Services\Documents\Search\BasedOnRepositoryDocumentKindFinder.pas',
  DocumentTypeDBResolver in 'Repositories\Documents\Common\Resolvers\DocumentTypeDBResolver.pas',
  PersonnelOrderSubKindPostgresRepository in 'Repositories\Documents\Personnel Orders\SQL\Postgres\PersonnelOrderSubKindPostgresRepository.pas',
  PersonnelOrderSubKindRepository in 'Repositories\Documents\Personnel Orders\Interfaces\PersonnelOrderSubKindRepository.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.
