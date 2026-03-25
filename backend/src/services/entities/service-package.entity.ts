import { Entity, Column } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';

export enum ServiceCategory {
  BASIC = 'basic',
  PREMIUM = 'premium',
  DETAIL = 'detail',
  SPECIALTY = 'specialty',
}

@Entity('service_packages')
export class ServicePackage extends BaseEntity {
  @Column()
  name: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'float' })
  price: number;

  @Column({ type: 'text', default: ServiceCategory.BASIC })
  category: ServiceCategory;

  @Column({ default: 60 })
  durationMinutes: number;

  @Column({ type: 'simple-array', nullable: true })
  features: string[];

  @Column({ nullable: true })
  imageUrl: string;

  @Column({ default: true })
  isActive: boolean;

  @Column({ default: 0 })
  sortOrder: number;

  @Column({ type: 'float', default: 0 })
  rating: number;

  @Column({ default: 0 })
  totalBookings: number;
}
