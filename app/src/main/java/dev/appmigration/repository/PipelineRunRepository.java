package dev.appmigration.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import dev.appmigration.domain.PipelineRun;

@Repository
public interface PipelineRunRepository extends JpaRepository<PipelineRun, UUID> {

    Optional<PipelineRun> findByDeploymentId(UUID deploymentId);
}